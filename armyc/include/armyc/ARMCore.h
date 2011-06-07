#ifndef _ARMYC_ARMYCORE_H_
#define _ARMYC_ARMYCORE_H_

#import <Chiles/ChTypes.h>
#import <Chiles/ChObject.h>
#import <Chiles/ChList.h>
#import <Chiles/ChConf.h>
#import <pthread.h>

#define mode_usr 0x10
#define mode_fiq 0x11
#define mode_irq 0x12
#define mode_svc 0x13
#define mode_abt 0x17
#define mode_und 0x1b
#define mode_sys 0x1f

#define status_m 0
#define status_t 5
#define status_ge 16
#define status_f 6
#define status_i 7
#define status_a 8
#define status_e 9
#define status_j 24
#define status_q 27
#define status_v 28 
#define status_c 29
#define status_z 30
#define status_n 31

#define little_endian 0
#define big_endian 0

@protocol ARMMemoryInterface

-(Byte)readByteAt:(UWord)addr;
/*
-(Halfword)readHalfwordAt:(UWord)addr;
-(Word)readWordAt:(UWord)addr;
*/

-(void)writeByte:(Byte)val at:(Word)addr;
/*
-(void)writeHalfword:(Halfword)val at:(Word)addr;
-(void)writeWord:(Word)val at:(Word)addr;
*/

-(UWord)size;
-(UWord)baseAddr;

@end

@interface ARMCore : ChObject {
	UWord *_r;
	UWord *_r_svc;
	UWord *_r_abt;
	UWord *_r_und;
	UWord *_r_irq;
	UWord *_r_fiq;

	UWord _cpsr;
	UWord _spsr_svc;
	UWord _spsr_abt;
	UWord _spsr_und;
	UWord _spsr_irq;
	UWord _spsr_fiq;

	ChList *memory;
	ChConf *config;
	ChList *_insts;
	
	pthread_t thread;

	pthread_mutex_t mutex;

	Word paused;
	Word stopped;

	ChString *elog;
	ChString *dlog;

	ChDictionary *instCache;

	ChArray *coprocs;
	ChObject *_pythonListener;

	FILE *debugFile;
}

-(id)initWithConf:(ChConf *)conf withElog:(ChString *)el
                                 withDlog:(ChString *)dl;
-(void)setDebugFile:(FILE *)df;
-(UWord)mode;
-(void)setMode:(UWord)mode;
-(void)reset;
-(void)writeReg:(Word)reg value:(UWord)value;
-(UWord)readReg:(Word)reg;

-(void)writeSvcReg:(Word)reg value:(UWord)value;
-(void)writeSvcSrc:(Word)value;
-(UWord)readRegUsr:(Word)reg;

-(Byte)readByteAt:(UWord)address;
-(Halfword)readHalfwordAt:(UWord)address;
-(Word)readWordAt:(UWord)address;

-(void)writeByte:(Byte)byte at:(UWord)address;
-(void)writeHalfword:(Halfword)halfword at:(UWord)address;
-(void)writeWord:(Word)word at:(UWord)address;
-(Word)endianess;

-(Word)statusFor:(Word)st;
-(Word)setStatus:(Word)st forFlag:(Word)flag;

-(Word)cpsr;
-(Word)spsr;

-(void)setCpsr:(Word)cpsr;
-(void)setSpsr:(Word)spsr;

-(void)start;
-(void)resume;
-(void)pause;
-(void)stop;

-(void)addDevice:(id<ARMMemoryInterface>)dev;

-(ChConf *)conf;
-(ChList *)insts;

-(ChString *)execLog;
-(ChString *)debugLog;

-(void)setInstructions:(ChList *)insts;

-(id)fetch:(UWord)instcode;

-(ChObject *)getCoprocAt:(Word)index;
-(Word)paused;
-(Word)stopped;

-(pthread_mutex_t *)lock;

-(BOOL)hasSpsr;

-(ChObject *)pythonListener;

-(void)debug:(ChString *)fmt, ...;

@end

#endif

