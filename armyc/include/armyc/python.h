#ifndef _ARMYC_LUA_H
#define _ARMYC_LUA_H

#import <Python.h>
#import <armyc/ARMCore.h>
#import <armyc/ARMPythonEvent.h>
#import <armyc/ARMPythonDevice.h>
#import <armyc/ishell.h>
#import <readline/readline.h>
#import <readline/history.h>

void ishell(struct arguments *, ARMCore *);

typedef struct {
	PyObject_HEAD
	ARMCore *core;
} armyc_ARMCore;


#define PROC "Core"

PyObject *ARMCore_writeReg(PyObject *self, PyObject *args);
PyObject *ARMCore_readReg(PyObject *self, PyObject *args);
PyObject *ARMCore_writeWord(PyObject *self, PyObject *args);
PyObject *ARMCore_readWord(PyObject *self, PyObject *args);
PyObject *ARMCore_writeHalfword(PyObject *self, PyObject *args);
PyObject *ARMCore_readHalfword(PyObject *self, PyObject *args);
PyObject *ARMCore_writeByte(PyObject *self, PyObject *args);
PyObject *ARMCore_readByte(PyObject *self, PyObject *args);
PyObject *ARMCore_resume(PyObject *self);
PyObject *ARMCore_pause(PyObject *self);

static PyMethodDef ARMCore_methods[] = {
	{"writeReg", (PyCFunction)ARMCore_writeReg, METH_VARARGS,
	             "write reg"},
	{"readReg", (PyCFunction)ARMCore_readReg, METH_VARARGS,
	             "read reg"},
	{"writeWord", (PyCFunction)ARMCore_writeWord, METH_VARARGS,
	             "write Word"},
	{"readWord", (PyCFunction)ARMCore_readWord, METH_VARARGS,
	             "read Word"},
	{"writeHalfword", (PyCFunction)ARMCore_writeHalfword, METH_VARARGS,
	             "write halfword"},
	{"readHalfword", (PyCFunction)ARMCore_readHalfword, METH_VARARGS,
	             "read halfword"},
	{"writeByte", (PyCFunction)ARMCore_writeByte, METH_VARARGS,
	             "write byte"},
	{"readByte", (PyCFunction)ARMCore_readByte, METH_VARARGS,
	             "read byte"},
	{"resume", (PyCFunction)ARMCore_resume, METH_NOARGS,
	             "resume core"},
	{"pause", (PyCFunction)ARMCore_pause, METH_NOARGS,
	             "pause core"},
	{NULL, NULL, 0, NULL}
};


static PyTypeObject armyc_ARMCoreType = {
    PyObject_HEAD_INIT(NULL)
    0,                         /*ob_size*/
    "armyc.ARMCore",           /*tp_name*/
    sizeof(armyc_ARMCore),     /*tp_basicsize*/
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
    ARMCore_methods,           /* tp_methods */
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

static PyMethodDef armyc_methods[] = {
	{NULL}
};

typedef struct {
	PyObject_HEAD
	ARMPythonEventListener *events;
} armyc_ARMEvents;

#define LISTENER "listener"

PyObject *ARMEvents_hasEvents(PyObject *self);
PyObject *ARMEvents_executeAll(PyObject *self);

static PyMethodDef ARMEvents_methods[] = {
	{"hasEvents", (PyCFunction)ARMEvents_hasEvents, METH_NOARGS,
	             "check if has events"},
	{"executeAll", (PyCFunction)ARMEvents_executeAll, METH_NOARGS,
	             "execute all events"},
	{NULL, NULL, 0, NULL}
};


static PyTypeObject armyc_ARMEventsType = {
    PyObject_HEAD_INIT(NULL)
    0,                         /*ob_size*/
    "armyc.ARMEvents",         /*tp_name*/
    sizeof(armyc_ARMEvents),     /*tp_basicsize*/
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
    ARMEvents_methods,           /* tp_methods */
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


#ifndef PyMODINIT_FUNC
#define PyMODINIT_FUNC void
#endif

PyMODINIT_FUNC initarmyc(ARMCore *);

#endif

