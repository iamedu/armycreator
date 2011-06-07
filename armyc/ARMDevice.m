#import <armyc/ARMDevice.h>
#import <Chiles/ChString.h>

void startThread(ARMDevice *device) {
	SEL run = [device getRunSelector];
	[device performSelector:run];
}

@implementation ARMDevice 

-(id)initWithSize:(UWord)s withCore:(ARMCore *)c withBase:(UWord)b {
	si   = s;
	core = c;
	base = b;
	memory = (Byte *)malloc(sizeof(Byte) * s);

	pthread_mutex_init(&mutex, NULL);

	[core addDevice:self];

	return self;
}

-(Byte)readByteAt:(UWord)addr {
	Byte value;
	addr -= base;


	pthread_mutex_lock(&mutex);
	value = memory[addr];
	pthread_mutex_unlock(&mutex);

	return value;
}

/*
-(Halfword)readHalfwordAt:(UWord)addr {
	Word endianess = [core endianess];
	Halfword result = 0;
	UWord i;

	addr -= base;

	pthread_mutex_lock(&mutex);
	if(endianess == little_endian) {
		for(i = 0; i < 2; i++) {
			result |= (memory[addr + i] << i * 8) &
			                    (0xff << (i * 8));
		}
	} else {
		for(i = 1; i >= 0; i--) {
			result |= (memory[addr + 1 - i] << i * 8) &
			                    (0xff << (i * 8));
		}
	}
	pthread_mutex_unlock(&mutex);

	return result;
}

-(Word)readWordAt:(UWord)addr {
	Word endianess = [core endianess];
	Word result = 0;
	UWord i;

	addr -= base;

	pthread_mutex_lock(&mutex);
	if(endianess == little_endian) {
		for(i = 0; i < 4; i++) {
			result |= (memory[addr + i] << i * 8) &
			                    (0xff << (i * 8));
		}
	} else {
		for(i = 3; i >= 0; i--) {
			result |= (memory[addr + 3 - i] << i * 8) &
			                    (0xff << (i * 8));
		}
	}
	pthread_mutex_unlock(&mutex);

	return result;
}
*/

-(void)writeByte:(Byte)val at:(Word)addr {
	addr -= base;
	pthread_mutex_lock(&mutex);
	memory[addr] = val;
	pthread_mutex_unlock(&mutex);
}

/*
-(void)writeHalfword:(Halfword)val at:(Word)addr {
	Word endianess = [core endianess];
	UWord i;
	addr -= base;

	pthread_mutex_lock(&mutex);
	if(endianess == little_endian) {
                for(i = 0; i < 2; i++) {
                        memory[addr + i] =
                                  (val & (0x000000FF << (i * 8))) >> (i * 8);
                }
        } else {
                for(i = 1; i >= 0; i--) {
                        memory[addr + 1 - i] =
                                  (val & (0x000000FF << (i * 8))) >> (i * 8);
                }
        }
	pthread_mutex_unlock(&mutex);

}

-(void)writeWord:(Word)val at:(Word)addr {
	Word endianess = [core endianess];
	UWord i;
	addr -= base;

	pthread_mutex_lock(&mutex);
	if(endianess == little_endian) {
                for(i = 0; i < 4; i++) {
                        memory[addr + i] =
                                  (val & (0x000000FF << (i * 8))) >> (i * 8);
                }
        } else {
                for(i = 3; i >= 0; i--) {
                        memory[addr + 3 - i] =
                                  (val & (0x000000FF << (i * 8))) >> (i * 8);
                }
        }
	pthread_mutex_unlock(&mutex);
}
*/

-(UWord)size {
	return si;
}

-(UWord)baseAddr {
	return base;
}

-(void)start {
	SEL start;
	start = @selector(start);
	pthread_create(&thread, NULL, (void *)&startThread, (void *)self);
}

-(void)run {
}

-(SEL)getRunSelector {
	return @selector(run);
}

-(void)stop {
}

-(void)free {
	[self stop];
	pthread_join(thread, NULL);
	[super free];
}

@end

