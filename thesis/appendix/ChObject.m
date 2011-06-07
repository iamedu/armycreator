#import <Chiles/ChObject.h>
#import <Chiles/ChString.h>

@implementation ChObject

+ (id) alloc {
	id new;      
	UWord size;  
	Class class;
	void *addr;  
	ChObjectExtra *extra; 

	class = self;
	size = class->instance_size + sizeof(ChObjectExtra);
	addr = malloc(size);
	new = addr;
	memset(new, 0, size);
	new->class_pointer = class;

	extra = (ChObjectExtra *)(addr + class->instance_size);
	extra->retainCount = 1;

	return new;
}

- (id) init {
	return self;
}

-(void)free {
	[self selfFree];
}

-(void)selfFree {
	free(self);
}

- (id) retain {
	void *addr;
	ChObjectExtra *extra;

	if([self isKindOfClass:[ChConstantString class]]) {
		return;
	}

	addr = self;
	extra = (ChObjectExtra *)(addr + isa->instance_size);
	extra->retainCount++;

	return self;
}

- (void) release {
	void *addr;
	ChObjectExtra *extra;

	if([self isKindOfClass:[ChConstantString class]]) {
		return;
	}
	

	addr = self;
	extra = (ChObjectExtra *)(addr + isa->instance_size);
	extra->retainCount--;

	/*
	 * This is our garbage collector! if our retainCount has reached 0
	 * we free our object
	 */
	if(extra->retainCount <= 0) {
		[self free];
	}

}

- (UWord) retainCount {
	void *addr;
	ChObjectExtra *extra;

	addr = self;
	extra = (ChObjectExtra *)(addr + isa->instance_size);

	return extra->retainCount;
}

- (BOOL) isEqual: (id)other {
	return (self == other);
}

- (BOOL) isKindOfClass: (Class)class {
	Class selfClass = isa;
	while(selfClass != Nil) {
		if(selfClass == class) {
			return YES;
		}
		selfClass = class_get_super_class(selfClass);
	}
	return NO;
}

- (BOOL) isMemberOfClass: (Class)class {
	return (class == isa);
}

+ (Class) class {
	return self;
}

+ (Class) superclass {
	return class_get_super_class(self);
}

- (id) self {
	return self;
}

- (Class) class {
	return isa;
}

- (Class) superclass {
	return class_get_super_class(isa);
}

-(ChString *)description {
	ChString *desc;
	ChString *className;
	ChString *chaddr;
	char *caddr;
	caddr = malloc(9);

	sprintf(caddr, "%x", (unsigned int)self);

	className = [[ChInmutableString alloc] initWithCString:(char *)isa->name];
	chaddr    = [[ChInmutableString alloc] initWithCString:caddr];
	

	desc = @"Instance of ";
	desc = [desc concat:className];
	desc = [desc concat:@" at 0x"];
	desc = [desc concat:chaddr];

	return desc;
}

- (id)performSelector:(SEL)sel {
	IMP msg = objc_msg_lookup(self, sel);
	if(!msg) {
		ChPrint(@"Invalid selector passed to %@", self);
		exit(1);
	}
	return (*msg)(self, sel);
}

- (IMP)methodFor:(SEL)sel {
	return (method_get_imp(object_is_instance(self)
			?class_get_instance_method(self->isa, sel)
			:class_get_class_method(self->isa, sel)));
}

@end

