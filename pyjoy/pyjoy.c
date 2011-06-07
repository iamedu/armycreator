#include "pyjoy.h"
#include <pthread.h>

PyObject *Controller_getName(PyObject *self) {
	pyjoy_Controller *c = (pyjoy_Controller *)self;
	return PyString_FromString(c->name);
}

PyObject *Controller_getFD(PyObject *self) {
	pyjoy_Controller *c = (pyjoy_Controller *)self;
	return PyInt_FromLong(c->fd);
}

PyObject *Controller_buttons(PyObject *self) {
	pyjoy_Controller *c = (pyjoy_Controller *)self;
	PyObject *t = PyTuple_New(c->buttons);
	int i;

	for(i = 0; i < c->buttons; i++) {
		PyTuple_SetItem(t, i, PyInt_FromLong(c->button[i]));
	}

	return t;
}

PyObject *Controller_axes(PyObject *self) {
	pyjoy_Controller *c = (pyjoy_Controller *)self;
	PyObject *t = PyTuple_New(c->axes);
	int i;

	for(i = 0; i < c->axes; i++) {
		PyTuple_SetItem(t, i, PyInt_FromLong(c->axis[i]));
	}

	return t;
}

int Controller_init(PyObject *self, PyObject *args, PyObject *kwds) {

	return 0;
}

typedef struct {
	pyjoy_Controller *self;
} ct_args;

void *buttons_reload(void *arg) {
	ct_args *args = (ct_args *)arg;
	pyjoy_Controller *self = args->self;
	struct js_event js;
	int ret = 0;
	while(1) {
		if(read(self->fd, &js, sizeof(struct js_event)) != sizeof(struct js_event)) {
			perror("\njstest: error reading");
			ret = 1;
			pthread_exit(&ret);
		}
		switch(js.type & ~JS_EVENT_INIT) {
		case JS_EVENT_BUTTON:
			self->button[js.number] = js.value;
			break;
		case JS_EVENT_AXIS:
			self->axis[js.number] = js.value;
			break;
		}
	}
	pthread_exit(&ret);
}

PyObject *Controller_new(PyTypeObject *type, PyObject *args, PyObject *kwds) {
	pyjoy_Controller *self;
	ct_args *a;

	self = (pyjoy_Controller *)type->tp_alloc(type, 0);

	if(self != NULL) {
		char *file;

		if(!PyArg_ParseTuple(args, "s", &file)) {
			return NULL;
		}
		//TODO: Initialize controller

		self->fd = open(file, O_RDONLY);
		self->axes = 2;
		self->buttons = 2;
		self->version = 0x000800;

		ioctl(self->fd, JSIOCGVERSION, &self->version);
		ioctl(self->fd, JSIOCGAXES, &self->axes);
		ioctl(self->fd, JSIOCGBUTTONS, &self->buttons);
		ioctl(self->fd, JSIOCGNAME(NAME_LENGTH), self->name);
		ioctl(self->fd, JSIOCGAXMAP, self->axmap);
		ioctl(self->fd, JSIOCGBTNMAP, self->btnmap);

		printf("Driver version is %d.%d.%d.\n",
		self->version >> 16, (self->version >> 8) & 0xff, self->version & 0xff);
		printf("Number of buttons: %d\n", self->buttons);
		printf("Number of axes: %d\n", self->axes);

		self->button = calloc(self->buttons, sizeof(char));
		self->axis = calloc(self->axes, sizeof(int));

		a = malloc(sizeof(ct_args));
		a->self = self;

		pthread_create(&self->thread, NULL, buttons_reload, a);
	}

	return (PyObject *)self;

}

PyMODINIT_FUNC initpyjoy(void) {
	PyObject *m;
	
	
	if (PyType_Ready(&pyjoy_ControllerType) < 0) {
		fprintf(stderr, "Could not add type\n");
		exit(1);
	}

	m = Py_InitModule("pyjoy", NULL);

	if(m == NULL)
		return;

	Py_INCREF(&pyjoy_ControllerType);
	PyModule_AddObject(m, "Controller", (PyObject *)&pyjoy_ControllerType);
}



