#ifndef _ARMYC_ARMDEVICE_H
#define _ARMYC_ARMDEVICE_H

#import <Chiles/ChObject.h>
#import <armyc/ARMCore.h>
#import <pthread.h>

@interface ARMDevice : ChObject<ARMMemoryInterface> {
	UWord base;
	Byte *memory;
	UWord si;
	ARMCore *core;
	pthread_mutex_t mutex;
	pthread_t thread;
}

-(id)initWithSize:(UWord)s withCore:(ARMCore *)c withBase:(UWord)b;
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

-(void)start;
-(void)run;
-(void)stop;

-(SEL)getRunSelector;

-(UWord)baseAddr;
-(UWord)size;

@end

#endif

