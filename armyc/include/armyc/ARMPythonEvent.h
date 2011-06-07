#ifndef _ARMYC_PYTHON_EVENT_H_
#define _ARMYC_PYTHON_EVENT_H_

#import <Chiles/ChObject.h>
#import <Chiles/ChArray.h>
#import <Chiles/ChList.h>
#import <pthread.h>

@interface ARMPythonEvent : ChObject {
	SEL sel;
	ChArray *args;
	ChObject *obj;
	ChObject *ret;
	BOOL executed;
}

-(id)initWithObj:(ChObject *)o withArgs:(ChArray *)a withMethod:(SEL)s;
-(void)execute;

@end

@interface ARMPythonEventListener : ChObject {
	ChList *events;
	pthread_mutex_t mutex;
}

-(void)addEvent:(ARMPythonEvent *)event;
-(BOOL)hasEvents;
-(void)executeAll;

@end

#endif

