#import <armyc/python.h>
#import <armyc/ishell.h>

#import <Chiles/ChString.h>

#import <string.h>
#import <config.h>
#import <readline/readline.h>
#import <readline/history.h>
#import <signal.h>

#define SIGINT	2

void shandler(int n) {
}

void setup_python(struct arguments *arguments) {
	ChString *initFile;
	FILE *scriptFile;
	char *script;
	script = arguments->script;

	if(script == NULL) {
		initFile = [[ChInmutableString alloc]
					initWithCString:getenv("HOME")];
		initFile = [initFile concat:@"/.armycrc"];
		scriptFile = fopen([initFile cString], "r");
		if(scriptFile == NULL) {
			scriptFile = fopen([initFile cString], "w");
			fprintf(scriptFile, "#!/bin/env python\n\n");
			fprintf(scriptFile, "def main():\n");
			fprintf(scriptFile, "    pass\n\n");
			fclose(scriptFile);
		}
		script = (char *)[initFile cString];
	} 

	scriptFile = fopen(script, "r");
	PyRun_SimpleFile(scriptFile, script);
	fclose(scriptFile);

}

void ishell(struct arguments *arguments, ARMCore *core) {
	char *command;
	int status;

	initarmyc(core);

	signal(SIGINT, &shandler);

	PyRun_SimpleString("import armycc");
	PyRun_SimpleString("armycc.start()");
	PyRun_SimpleString("main()");
	PyRun_SimpleString("armycc.loop()");

}

PyMODINIT_FUNC initarmyc(ARMCore *core) {
	PyObject *m;
	armyc_ARMCore *armCore;
	armyc_ARMEvents *armEvents;

	if (PyType_Ready(&armyc_ARMCoreType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	if (PyType_Ready(&armyc_ARMEventsType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	armCore = PyObject_GC_NewVar(armyc_ARMCore,
	                             &armyc_ARMCoreType,
				     1);

	armEvents = PyObject_GC_NewVar(armyc_ARMEvents,
	                             &armyc_ARMEventsType,
				     1);

	if (PyType_Ready(&armyc_MemoryWrapperType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	armCore->core = core;
	armEvents->events = [core pythonListener];

	m = Py_InitModule3("armyc", armyc_methods,
			   "armyc module to interface with armyc simulator");

	Py_INCREF(&armyc_ARMCoreType);
	Py_INCREF(&armyc_ARMEventsType);
	Py_INCREF(&armyc_MemoryWrapperType);
	PyModule_AddObject(m, "core", (PyObject *)armCore);
	PyModule_AddObject(m, "events", (PyObject *)armEvents);
	PyModule_AddObject(m, "MemoryWrapper", (PyObject *)&armyc_MemoryWrapperType);
}

PyObject *ARMCore_writeReg(PyObject *self, PyObject *args) {
	PyObject *reg;
	PyObject *value;
	armyc_ARMCore *armCore;
	int ireg;
	int ivalue;

	armCore = (armyc_ARMCore *)self;

	reg = PyTuple_GetItem(args, 0);
	value = PyTuple_GetItem(args, 1);
	
	ireg = (int)PyLong_AsLong(reg);
	ivalue = (int)PyLong_AsLong(value);

	[armCore->core writeReg:ireg value:ivalue];

	return Py_None;
}

PyObject *ARMCore_readReg(PyObject *self, PyObject *args) {
	PyObject *reg;
	PyObject *value;
	armyc_ARMCore *armCore;
	int ireg;
	int ivalue;
	armCore = (armyc_ARMCore *)self;

	reg = PyTuple_GetItem(args, 0);
	
	ireg = (int)PyLong_AsLong(reg);

	ivalue = [armCore->core readReg:ireg];

	value = (PyObject *)PyLong_FromLong((unsigned long)ivalue);

	//Py_INCREF(value);

	return value;
}

PyObject *ARMCore_writeWord(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;

	armCore = (armyc_ARMCore *)self;

	addr = PyTuple_GetItem(args, 0);
	value = PyTuple_GetItem(args, 1);
	
	iaddr = (UWord)PyLong_AsLong(addr);
	ivalue = (UWord)PyLong_AsLong(value);

	[armCore->core writeWord:ivalue at:iaddr];

	return Py_None;
}

PyObject *ARMCore_readWord(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;
	armCore = (armyc_ARMCore *)self;

	addr = PyTuple_GetItem(args, 0);
	
	iaddr = (UWord)PyLong_AsLong(addr);

	ivalue = [armCore->core readWordAt:iaddr];

	value = (PyObject *)PyLong_FromLong(ivalue);

	//Py_INCREF(value);

	return value;
}

PyObject *ARMCore_writeHalfword(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;

	armCore = (armyc_ARMCore *)self;

	addr = PyTuple_GetItem(args, 0);
	value = PyTuple_GetItem(args, 1);
	
	iaddr = (UWord)PyLong_AsLong(addr);
	ivalue = (Halfword)PyLong_AsLong(value);

	[armCore->core writeHalfword:ivalue at:iaddr];

	return Py_None;
}

PyObject *ARMCore_readHalfword(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;
	armCore = (armyc_ARMCore *)self;

	addr = PyTuple_GetItem(args, 0);
	
	iaddr = (UWord)PyLong_AsLong(addr);
	ivalue = (UWord)[armCore->core readHalfwordAt:iaddr];

	value = PyLong_FromLong((unsigned long)ivalue);

	//Py_INCREF(value);

	return value;
}

PyObject *ARMCore_writeByte(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;

	armCore = (armyc_ARMCore *)self;

	addr = PyTuple_GetItem(args, 0);
	value = PyTuple_GetItem(args, 1);
	
	iaddr = (UWord)PyLong_AsLongLong(addr);
	ivalue = (Byte)PyLong_AsLongLong(value);

	[armCore->core writeByte:ivalue at:iaddr];

	return Py_None;
}

PyObject *ARMCore_readByte(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_ARMCore *armCore;
	UWord iaddr;
	UWord ivalue;

	armCore = (armyc_ARMCore *)self;
	addr = PyTuple_GetItem(args, 0);
	iaddr = (UWord)PyLong_AsLongLong(addr);
	ivalue = [armCore->core readByteAt:iaddr];
	value = PyLong_FromLong((unsigned long)ivalue);

	//Py_INCREF(value);

	return value;
}

PyObject *ARMCore_resume(PyObject *self) {
	armyc_ARMCore *armCore;

	armCore = (armyc_ARMCore *)self;

	[armCore->core resume];

	return Py_None;
}

PyObject *ARMCore_pause(PyObject *self) {
	armyc_ARMCore *armCore;

	armCore = (armyc_ARMCore *)self;

	[armCore->core pause];

	return Py_None;
}

PyObject *ARMEvents_hasEvents(PyObject *self) {
	armyc_ARMEvents *armEvents;
	PyObject *value;

	armEvents = (armyc_ARMEvents *)self;

	value = PyLong_FromLong((unsigned long)[armEvents->events hasEvents]);
		
	//Py_INCREF(value);

	return value;
}

PyObject *ARMEvents_executeAll(PyObject *self) {
	armyc_ARMEvents *armEvents;
	armEvents = (armyc_ARMEvents *)self;

	[armEvents->events executeAll];

	return Py_None;
}

PyObject *MemoryWrapper_writeByte(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_MemoryWrapper *memory;
	UWord iaddr;
	UWord ivalue;

	memory = (armyc_MemoryWrapper *)self;

	addr = PyTuple_GetItem(args, 0);
	value = PyTuple_GetItem(args, 1);
	
	iaddr = (UWord)PyLong_AsLongLong(addr);
	ivalue = (Byte)PyLong_AsLongLong(value);

	[memory->memory writeByte:ivalue at:iaddr];

	return Py_None;
}

PyObject *MemoryWrapper_readByte(PyObject *self, PyObject *args) {
	PyObject *addr;
	PyObject *value;
	armyc_MemoryWrapper *memory;
	UWord iaddr;
	UWord ivalue;

	memory = (armyc_MemoryWrapper *)self;
	addr = PyTuple_GetItem(args, 0);
	iaddr = (UWord)PyLong_AsLong(addr);

	ivalue = [memory->memory readByte:iaddr];

	value = PyLong_FromLong((unsigned long)ivalue);

	//Py_INCREF(value);

	return value;
}


