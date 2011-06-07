#import <armyc/ARMPythonEvent.h>
#import <armyc/python.h>

@implementation ARMPythonEvent

-(id)initWithObj:(ChObject *)o withArgs:(ChArray *)a withMethod:(SEL)s {
	obj = o;
	args = a;
	sel = s;
	executed = 0;
	return self;
}

-(void)execute {
	IMP imp = [obj methodFor:sel];
	ret = imp(obj, sel, args);
	executed = 1;
}

@end

@implementation ARMPythonEventListener

-(id)init {
	events = [[ChList alloc] init];
	pthread_mutex_init(&mutex, NULL);
	return self;
}

-(void)addEvent:(ARMPythonEvent *)event {
	pthread_mutex_lock(&mutex);
	[events insert:event];
	pthread_mutex_unlock(&mutex);
}

-(BOOL)hasEvents {
	Py_INCREF(Py_None);
	return [events size] > 0;
}

-(void)executeAll {
	ChObject<Iterator> *it;	
	ARMPythonEvent *event;
	
	Py_INCREF(Py_None);

	it = [events iterator];

	pthread_mutex_lock(&mutex);
	while([it hasNext]) {
		event = (ARMPythonEvent *)[it next];
		[event execute];
	}
	[events clear];
	[it release];
	pthread_mutex_unlock(&mutex);
}

@end

