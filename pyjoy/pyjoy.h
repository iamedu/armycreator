#ifndef PYJOY_H
#define PYJOY_H

#include <Python.h>

#include <pthread.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include <linux/input.h>
#include <linux/joystick.h>

#define NAME_LENGTH 128

typedef struct {
	PyObject_HEAD
	int fd;
	unsigned char axes;
	unsigned char buttons;
	int version;
	char name[NAME_LENGTH];
	uint16_t btnmap[KEY_MAX - BTN_MISC + 1];
	uint8_t axmap[ABS_MAX + 1];
	char *button;
	int *axis;
	pthread_t thread;
} pyjoy_Controller;

PyObject *Controller_getName(PyObject *self);
PyObject *Controller_getFD(PyObject *self);
PyObject *Controller_buttons(PyObject *self);
PyObject *Controller_axes(PyObject *self);
int Controller_init(PyObject *self, PyObject *args, PyObject *kwds);
PyObject *Controller_new(PyTypeObject *type, PyObject *args, PyObject *kwds);

static PyMethodDef Controller_methods[] = {
	{"getName", (PyCFunction)Controller_getName, METH_NOARGS,
	                     "get controller name"},
	{"getFD", (PyCFunction)Controller_getFD, METH_NOARGS,
	                     "get controller file descriptor"},
	{"buttons", (PyCFunction)Controller_buttons, METH_NOARGS,
	                     "get controller buttons"},
	{"axes", (PyCFunction)Controller_axes, METH_NOARGS,
	                     "get controller axes"},
	{NULL, NULL, 0, NULL}
};

static PyTypeObject pyjoy_ControllerType = {
	PyObject_HEAD_INIT(NULL)
	0,
	"pyjoy.Controller",
	sizeof(pyjoy_Controller),
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
	"Controller object",         /* tp_doc */
	0,                         /* tp_traverse */
	0,                         /* tp_clear */
	0,                         /* tp_richcompare */
	0,                         /* tp_weaklistoffset */
	0,                         /* tp_iter */
	0,                         /* tp_iternext */
	Controller_methods,
	0,                         /* tp_members */
	0,                         /* tp_getset */
	0,                         /* tp_base */
	0,                         /* tp_dict */
	0,                         /* tp_descr_get */
	0,                         /* tp_descr_set */
	0,                         /* tp_dictoffset */
	(initproc)Controller_init,           /* tp_init */
	0,                         /* tp_alloc */
	Controller_new,                         /* tp_new */
};

#ifndef PyMODINIT_FUNC
#define PyMODINIT_FUNC void
#endif

PyMODINIT_FUNC initpyjoy();

#endif

