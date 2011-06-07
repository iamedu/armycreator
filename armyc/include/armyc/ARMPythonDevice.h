#ifndef _ARMYC_ARMEXTERNALDEVICE_H
#define _ARMYC_ARMEXTERNALDEVICE_H

#import <Python.h>
#import <armyc/ARMDevice.h>
#import <Chiles/ChString.h>
#import <Chiles/ChArray.h>

@interface MemoryWrapper : ChObject {
	char *memory;
	pthread_mutex_t *mutex;
}

-(id)initWithMemory:(char *)mem withMutex:(pthread_mutex_t *)m;
-(Byte)readByte:(UWord)addr;
-(void)writeByte:(Byte)val at:(UWord)addr;

@end

typedef struct {
	PyObject_HEAD
	MemoryWrapper *memory;
} armyc_MemoryWrapper;

PyObject *MemoryWrapper_writeByte(PyObject *self, PyObject *args);
PyObject *MemoryWrapper_readByte(PyObject *self, PyObject *args);

static PyMethodDef MemoryWrapper_methods[] = {
	{"writeByte", (PyCFunction)MemoryWrapper_writeByte, METH_VARARGS,
	             "check if has events"},
	{"readByte", (PyCFunction)MemoryWrapper_readByte, METH_VARARGS,
	             "execute all events"},
	{NULL, NULL, 0, NULL}
};


static PyTypeObject armyc_MemoryWrapperType = {
    PyObject_HEAD_INIT(NULL)
    0,                         /*ob_size*/
    "armyc.MemoryWrapper",         /*tp_name*/
    sizeof(armyc_MemoryWrapper),     /*tp_basicsize*/
    0,                         /*tp_itemsize*/
    0,                         /*tp_dealloc*/
    0,                         /*tp_print*/
    0,                         /*tp_getattr*/
    0,                         /*tp_setattr*/
    0,                         /*tp_compare*/
    0,                         /*tp_repr*/
    0,                         /*tp_as_number*/
    0,                         /*tp_as_sequence*/
    0,                         /*tp_as_mapping*/
    0,                         /*tp_hash */
    0,                         /*tp_call*/
    0,                         /*tp_str*/
    0,                         /*tp_getattro*/
    0,                         /*tp_setattro*/
    0,                         /*tp_as_buffer*/
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,        /*tp_flags*/
    "ARMCore objects",         /* tp_doc */
    0,		               /* tp_traverse */
    0,		               /* tp_clear */
    0,		               /* tp_richcompare */
    0,		               /* tp_weaklistoffset */
    0,		               /* tp_iter */
    0,		               /* tp_iternext */
    MemoryWrapper_methods,           /* tp_methods */
    0,		               /* tp_members */
    0,                         /* tp_getset */
    0,                         /* tp_base */
    0,                         /* tp_dict */
    0,                         /* tp_descr_get */
    0,                         /* tp_descr_set */
    0,                         /* tp_dictoffset */
    0,      	               /* tp_init */
    0,                         /* tp_alloc */
    0,                         /* tp_new */

};


@interface ARMPythonDevice : ARMDevice {
	ChConf *config;
	PyObject *module;
	PyObject *class;
	PyObject *instance;
	MemoryWrapper *memoryWrapper;
}

-(id)initWithCore:(ARMCore *)c withBase:(UWord)b
                               withConf:(ChConf *)conf
			       withName:(ChString *)name;

-(void)pythonWriteByte:(ChArray *)args;
-(void)pythonReadByte:(ChArray *)args;

@end

#endif

