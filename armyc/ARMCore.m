#import <armyc/ARMCore.h>
#import <armyc/ARMInstruction.h>
#import <armyc/ARMAddressing.h>
#import <armyc/ARMPythonEvent.h>
#import <Chiles/ChString.h>
#import <Chiles/ChInteger.h>
#import <stdarg.h>

void loop(ARMCore *core) {
	ARMInstruction *instruction;
	UWord inst;
	UWord addr;
	char *dlog = NULL;
	FILE *dlogFile = NULL;
	int result;

	if([core debugLog] != NULL) {
		dlog = (char *)[[core debugLog] cString];
		dlogFile = fopen(dlog, "w");
		[core setDebugFile:dlogFile];
	}

	while(![core stopped]) {
		if([core paused]) {
			pthread_mutex_lock([core lock]);
		}

		addr = [core readReg:15] - 4;
		inst = [core readWordAt:addr];

		instruction = [core fetch:inst];
		[core writeReg:15 value:(addr + 4)];

		[core debug:@"Tried to execute inst at addr[%x]: %@\n", addr, instruction];
		[core debug:@"Register 14 is: %x\n", [core readReg:14]];
		[core debug:@"Register 0 is: %x\n", [core readReg:0]];
		[core debug:@"Register 1 is: %x\n", [core readReg:1]];
		[core debug:@"Register 2 is: %x\n", [core readReg:2]];
		result = [instruction execute];

		if(result < 0) {
			[core debug:@"Not implemented inst %x at %d\n",
				    inst,
				    addr];
		} else if(result > 0) {
			[core writeReg:15 value:((result - 1) * 4)];
			continue;
		}

		if(instruction == (ARMInstruction *)Nil) {
			[core debug:@"Undefined inst %x at %d\n\n",
				    inst,
				    addr];
			[core writeReg:15 value:((UND_EX - 1) * 4)];
			continue;
		}
		[core debug:@"Executed instruction at addr[%x]: %@\n\n", addr, instruction];

	}

	if(dlogFile != NULL) {
		fclose(dlogFile);
	}
	
}

@implementation ARMCore 

-(id)init {
	int i;
	self = [super self];
	paused = 1;
	stopped = 0;
	memory = [[ChList alloc] init];
	pthread_mutex_init(&mutex, NULL);
	pthread_mutex_lock(&mutex);
	instCache = [[ChDictionary alloc] initWithCapacity:512];
	coprocs = [[ChArray alloc] initWithLength:16];

	_r = malloc(sizeof(UWord) * 15);
	_r_svc = malloc(sizeof(UWord) * 2);
	_r_abt = malloc(sizeof(UWord) * 2);
	_r_und = malloc(sizeof(UWord) * 2);
	_r_irq = malloc(sizeof(UWord) * 2);
	_r_fiq = malloc(sizeof(UWord) * 8);

	for(i = 0; i < 16; i++) {
		_r[i] = 0;
	}

	for(i = 0; i < 3; i++) {
		_r_svc[i] = 0;
		_r_abt[i] = 0;
		_r_und[i] = 0;
		_r_irq[i] = 0;
	}

	for(i = 0; i < 9; i++) {
		_r_fiq[i] = 0;
	}

	_pythonListener = [[ARMPythonEventListener alloc] init];

	debugFile = NULL;

	return self;
}

-(Word)paused {
	return paused;
}

-(Word)stopped {
	return stopped;
}

-(UWord)mode {
	return _cpsr & 0x1f;
}

-(void)setMode:(UWord)mode {
	_cpsr = mode & 0x1f;
}

-(void)reset {
	_cpsr = mode_svc | 0x1c0;
	_r[15] = 0;
}

-(void)writeReg:(Word)reg value:(UWord)value {
	int mode;
	mode = [self mode];

	if(reg < 8) {
		_r[reg] = value;
		return;
	} else if(reg == 15) {
		_r[reg] = value;
		return;
	}

	if(mode != mode_fiq && reg < 13) {
		_r[reg] = value;
		return;
	}

	if(mode == mode_fiq) {
		reg -= 8;
		_r_fiq[reg] = value;
		return;
	} else if(mode == mode_usr || mode == mode_sys) {
		_r[reg] = value;
		return;
	} else if(mode == mode_svc) {
		reg -= 13;
		_r_svc[reg] = value;
		return;
	} else if(mode == mode_abt) {
		reg -= 13;
		_r_abt[reg] = value;
		return;
	} else if(mode == mode_und) {
		reg -= 13;
		_r_und[reg] = value;
		return;
	} else if(mode == mode_irq) {
		reg -= 13;
		_r_irq[reg] = value;
		return;
	}


}

-(void)writeSvcReg:(Word)reg value:(UWord)value {
	_r_svc[value - 13] = value;
}

-(void)writeSvcSrc:(Word)value {
	_spsr_svc = value;
}

-(UWord)readRegUsr:(Word)reg {
	return _r[reg];
}

-(UWord)readReg:(Word)reg {
	int mode;

	mode = [self mode];

	if(reg < 8) {
		return _r[reg];
	} else if(reg == 15) {
		return _r[reg] + 4;
	}

	if(mode != mode_fiq && reg < 13) {
		return _r[reg];
	}

	switch(mode) {
		case mode_fiq:
			reg -= 8;
			return _r_fiq[reg];
			break;
		case mode_usr:
		case mode_sys:
			return _r[reg];
			break;
		case mode_svc:
			reg -= 13;
			return _r_svc[reg];
			break;
		case mode_abt:
			reg -= 13;
			return _r_abt[reg];
			break;
		case mode_und:
			reg -= 13;
			return _r_und[reg];
			break;
		case mode_irq:
			reg -= 13;
			return _r_irq[reg];
			break;
	}

	return 0;
}

-(Byte)readByteAt:(UWord)address {
	id<Iterator> it;
	id<ARMMemoryInterface> mem;

	it = [memory iterator];

	while([it hasNext]) {
		mem = (id<ARMMemoryInterface>)[it next];
		if(address >= [mem baseAddr] &&
		   address < ([mem baseAddr] + [mem size])) {
			[it release];
			return [mem readByteAt:address];
		}
	}

	[it release];
	//HERE WE SHOULD SEND AN EXCEPTION
	return 0;
}

-(Halfword)readHalfwordAt:(UWord)address {
	Word endianess = [self endianess];
	Halfword result = 0;
	UWord addr = address;
	int i;


	if(endianess == little_endian) {
		for(i = 0; i < 2; i++) {
			result |=
				([self readByteAt:addr + i] << i * 8) &
						(0xff << (i * 8));
		}
	} else {
		for(i = 1; i >= 0; i--) {
			result |=
				([self readByteAt:addr + 1 - i] << i * 8) &
						(0xff << (i * 8));
		}
	}
	return result;
}

-(Word)readWordAt:(UWord)address {
	Word endianess = [self endianess];
	UWord result = 0;
	UWord addr = address;
	int i;



	if(endianess == little_endian) {
		for(i = 0; i < 4; i++) {
			result |=
				([self readByteAt:addr + i] << i * 8) &
						(0xff << (i * 8));
		}
	} else {
		for(i = 3; i >= 0; i--) {
			result |=
				([self readByteAt:addr + 3 - i] << i * 8) &
						(0xff << (i * 8));
		}
	}
	

	return result;
}

-(void)writeByte:(Byte)byte at:(UWord)address {
	id<Iterator> it;
	id<ARMMemoryInterface> mem;

	it = [memory iterator];


	while([it hasNext]) {
		mem = (id<ARMMemoryInterface>)[it next];
		if(address >= [mem baseAddr] &&
		   address < ([mem baseAddr] + [mem size])) {
			[it release];
			[mem writeByte:byte at:address];
			return;
		}
	}
	[it release];

	//HERE WE SHOULD SEND AN EXCEPTION
}

-(void)writeHalfword:(Halfword)halfword at:(UWord)address {
	id<ARMMemoryInterface> mem;
	Word endianess = [self endianess];
	UWord addr = address;
	int i;

	if(endianess == little_endian) {
		for(i = 0; i < 2; i++) {
			[self writeByte:
			      (halfword & (0x000000FF << (i * 8))) >> (i * 8)
			      at:(addr + i)];
		}
	} else {
		for(i = 1; i >= 0; i--) {
			[self writeByte:
			(halfword & (0x000000FF << (i * 8))) >> (i * 8)
			at:(addr + 1 - i)];
		}
	}
}

-(void)writeWord:(Word)word at:(UWord)address {
	Word endianess = [self endianess];
	UWord addr = address;
	int i;


	if(endianess == little_endian) {
		for(i = 0; i < 4; i++) {
			[self writeByte:
				(word & (0x000000FF << (i * 8))) >> (i * 8)
			     at:(addr + i)];
		}
	} else {
		for(i = 3; i >= 0; i--) {
			[self writeByte:
				(word & (0x000000FF << (i * 8))) >> (i * 8)
			     at:(addr + 3 - i)];
		}
	}
}

-(Word)endianess {
	return little_endian;
}

-(void)free {
	[memory release];
	[super free];
}

-(void)addDevice:(id<ARMMemoryInterface>)dev {
	[memory insert:(ChObject *)dev];
}

-(id)initWithConf:(ChConf *)conf withElog:(ChString *)el
                                 withDlog:(ChString *)dl {
	self = [self init];
	config = conf;
	elog = el;
	dlog = dl;
	return self;
}

-(ChConf *)conf {
	return config;
}

-(void)setInstructions:(ChList *)insts {
	_insts = insts;
}

-(void)start {
	[self setMode:mode_svc];
	pthread_create(&thread, NULL, (void *)&loop, self);
}

-(void)resume {
	paused = 0;
	pthread_mutex_unlock(&mutex);
}

-(void)pause {
	paused = 1;
}

-(void)stop {
	stopped = 1;
	[self resume];
}

-(ChList *)insts {
	return _insts;
}

-(ChString *)execLog {
	return elog;
}

-(ChString *)debugLog {
	return dlog;
}

-(pthread_mutex_t *)lock {
	return &mutex;
}

-(id)fetch:(UWord)instcode {
	Class class;
	ChInteger *inst;
	ARMInstruction *instruction = (ARMInstruction *)Nil;
	id<Iterator> it;
	id result;

	it = [[self insts] iterator];
	
	inst = [[ChInteger alloc] initFromInt:instcode];
	instruction = (ARMInstruction *)[instCache get:inst];
	[inst release];

	if(instruction != (ARMInstruction *)Nil) {
		[it release];
		return instruction;
	}

	while([it hasNext]) {
		class = (Class)[it next];
		result = (BOOL)[class isInstruction:instcode];
		if(result) {
			instruction = [[class alloc] initWithInstcode:instcode
							 core:self];
			inst = [[ChInteger alloc] initFromInt:instcode];
			[instCache put:instruction at:inst];
			[it release];
			return instruction;
		}
	}

	[it release];
	return Nil;
}

-(Word)cpsr {
	return _cpsr;
}

-(Word)spsr {
	Word mode = [self mode];

	switch(mode) {
		case mode_svc:
			return _spsr_svc;
			break;
		case mode_abt:
			return _spsr_abt;
			break;
		case mode_und:
			return _spsr_und;
			break;
		case mode_irq:
			return _spsr_irq;
			break;
		case mode_fiq:
			return _spsr_fiq;
			break;
	}

	return -1;
}

-(BOOL)hasSpsr {
	Word mode = [self mode];

	return (mode == mode_svc) || (mode == mode_abt) || 
	       (mode == mode_und) || (mode == mode_irq) ||
	       (mode == mode_fiq);
}

-(Word)statusFor:(Word)st {
	Word tmp;
	Word bitmask;

	tmp = [self cpsr];

	if(st == status_m) {
		bitmask = 0x1f;
	} else if(st == status_ge) {
		bitmask = 0xf;
	} else {
		bitmask = 1;
	}

	return (tmp >> st) & bitmask;
}

-(Word)setStatus:(Word)st forFlag:(Word)flag {
	//Declarations
	Word bitmask;
	UWord ubitmask;	
	//Initializations
	
	//Process
	if(flag == status_m) {
		bitmask = 0x1f;
	} else if(flag == status_ge) {
		bitmask = 0xf;
	} else {
		bitmask = 1;
	}
	
	//Valida si tiene el tamaño correcto usando un maskara
	st &= bitmask; 
 	
	//Generar la mascara para enCerar
	ubitmask= bitmask;
	ubitmask= ~(ubitmask << flag);
	
	//Aplicamos la mascar enCerada
	_cpsr &= ubitmask;
	//Se actualiza el nuevo valor en el procesador
	_cpsr |= (st << flag);
}

-(void)setCpsr:(Word)cpsr {
	_cpsr = cpsr;
}

-(void)setSpsr:(Word)spsr {
	Word mode = [self mode];

	switch(mode) {
		case mode_svc:
			_spsr_svc = spsr;
			break;
		case mode_abt:
			_spsr_abt = spsr;
			break;
		case mode_und:
			_spsr_und = spsr;
			break;
		case mode_irq:
			_spsr_irq = spsr;
			break;
		case mode_fiq:
			_spsr_fiq = spsr;
			break;
	}
}

-(ChObject *)getCoprocAt:(Word)index {
	return [coprocs get:index];
}

-(ChObject *)pythonListener {
	return _pythonListener;
}

-(void)setDebugFile:(FILE *)df {
	debugFile = df;
}

-(void)debug:(ChString *)fmt, ... {
	va_list ap;

	if(debugFile == NULL)
		return;

	va_start(ap, fmt);
	ChFLPrint(debugFile, fmt, ap);
	fflush(debugFile);
	va_end(ap);
}

@end

