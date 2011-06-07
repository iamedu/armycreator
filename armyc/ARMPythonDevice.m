#import <armyc/ARMPythonDevice.h>
#import <armyc/ARMPythonEvent.h>
#import <Chiles/ChInteger.h>
#import <armyc/python.h>

@implementation ARMPythonDevice 

-(id)initWithCore:(ARMCore *)c withBase:(UWord)b
                           withConf:(ChConf *)conf
			   withName:(ChString *)name {
	ChObject<Iterator> *it;
	ChObject<Iterator> *itsec;
	ChDictionary *sections;
	ChDictionary *section;
	UWord size = 0;
	ChDictionaryElement *el;
	ChDictionaryElement *elsec;
	ChString *tmpstr;
	ChString *tmpval;
	ChString *tmpstrsec;
	ChString *moduleName;
	ChString *className;
	PyObject *pySize;
	PyObject *pyConf;
	PyObject *pySection;
	PyObject *pyTuple;
	PyObject *pyValue;
	PyObject *pyBase;
	PyObject *pyName;
	armyc_MemoryWrapper *pyMemoryWrapper;
	armyc_ARMCore *pyCore;
	int i;

	pyConf = PyDict_New();
	pyTuple = PyTuple_New(5);

	sections = [conf sections];

	it = [[sections keys] iterator];

	while([it hasNext]) {
		tmpstr = (ChString *)[it next];
		section = (ChDictionary *)[sections get:tmpstr];
		pySection = PyDict_New();
		itsec = [[section keys] iterator];
		while([itsec hasNext]) {
			tmpstrsec = (ChString *)[itsec next];
			tmpval = (ChString *)[section get:tmpstrsec];
			pyValue = PyString_FromString([tmpval cString]);
			Py_INCREF(pyValue);
			PyDict_SetItemString(pySection, 
			                     [tmpstrsec cString],
					     pyValue);
		}
		[itsec release];
		Py_INCREF(pySection);
		PyDict_SetItemString(pyConf, [tmpstr cString],
		                     pySection);
	}
	[it release];

	moduleName = [conf get:@"lib" at:name];
	className = [conf get:@"sym" at:name];

	module = PyImport_ImportModule([moduleName cString]);
	class = PyObject_GetAttrString(module, [className cString]);
	pySize = PyObject_GetAttrString(class, "size");

	size = PyLong_AsLong(pySize);

	self = [super initWithSize:size withCore:c withBase:b];

	memoryWrapper = [[MemoryWrapper alloc] initWithMemory:memory
		                                   withMutex:&mutex];

	if (PyType_Ready(&armyc_MemoryWrapperType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	if (PyType_Ready(&armyc_ARMCoreType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	pyCore = PyObject_GC_NewVar(armyc_ARMCore,
	                            &armyc_ARMCoreType,
				    1);
	Py_INCREF(&armyc_ARMCoreType);
	Py_INCREF(&pyCore);
	pyCore->core = c;

	pyMemoryWrapper = PyObject_GC_NewVar(armyc_MemoryWrapper,
			                     &armyc_MemoryWrapperType,
					     1);
	Py_INCREF(&armyc_MemoryWrapperType);

	pyMemoryWrapper->memory = memoryWrapper;
	
	pyName = PyString_FromString([name cString]);
	pyBase = PyLong_FromLong(base);

	PyTuple_SetItem(pyTuple, 0, pyName);
	PyTuple_SetItem(pyTuple, 1, pyBase);
	PyTuple_SetItem(pyTuple, 2, pyMemoryWrapper);
	PyTuple_SetItem(pyTuple, 3, pyConf);
	PyTuple_SetItem(pyTuple, 4, pyCore);

	instance = PyObject_CallObject(class, pyTuple);

	config = conf;

	return self;
}

-(Byte)readByteAt:(UWord)addr {
	Byte value;
	ChArray *args = [[ChArray alloc] initWithLength:2];
	ChInteger *chaddr;
	ARMPythonEventListener *listener;
	ARMPythonEvent *event;
	
	value = [super readByteAt:addr];

	chaddr = [[ChInteger alloc] initFromInt:addr];

	[args set:chaddr at:0];

	listener = (ARMPythonEventListener *)[core pythonListener];
	event = [[ARMPythonEvent alloc] initWithObj:self
		                        withArgs:args
					withMethod:@selector(pythonReadByte:)];

	[listener addEvent:event];

	return value;
}


-(void)writeByte:(Byte)val at:(Word)addr {
	ChArray *args = [[ChArray alloc] initWithLength:2];
	ChInteger *chaddr;
	ChInteger *chval;
	ARMPythonEventListener *listener;
	ARMPythonEvent *event;

	[super writeByte:val at:addr];
	
	chaddr = [[ChInteger alloc] initFromInt:addr];
	chval  = [[ChInteger alloc] initFromInt:val];

	[args set:chaddr at:0];
	[args set:chval  at:1];

	listener = (ARMPythonEventListener *)[core pythonListener];
	event = [[ARMPythonEvent alloc] initWithObj:self
		                        withArgs:args
					withMethod:@selector(pythonWriteByte:)];

	[listener addEvent:event];
}

-(void)pythonWriteByte:(ChArray *)args {
	Word addr;
	Word val;

	ChInteger *chaddr;
	ChInteger *chval;



	chaddr = (ChInteger *)[args get:0];
	chval  = (ChInteger *)[args get:1];

	addr = [chaddr value];
	val  = [chval value];

	addr -= base;
	PyObject_CallMethod(instance, "writeByte", "i i", addr, val);
}

-(void)pythonReadByte:(ChArray *)args {
	ChInteger *chaddr;
	UWord addr;
        Byte value;

	chaddr = (ChInteger *)[args get:0];
	addr = [chaddr value];

        addr -= base;

	PyObject_CallMethod(instance, "readByte", "i", addr);
}


@end

@implementation MemoryWrapper 

-(id)initWithMemory:(char *)mem withMutex:(pthread_mutex_t *)m {
	memory = mem;
	mutex = m;

	return self;
}

-(Byte)readByte:(UWord)addr {
	Byte val;
        pthread_mutex_lock(mutex);
	val = memory[addr];
        pthread_mutex_unlock(mutex);
	return val;
}

-(void)writeByte:(Byte)val at:(UWord)addr {
        pthread_mutex_lock(mutex);
	memory[addr] = val;
        pthread_mutex_unlock(mutex);
}


@end

