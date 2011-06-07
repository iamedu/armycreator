#include <controller.h>
#include <list.h>

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

#define UP 4
#define DOWN 6
#define RIGHT 5
#define LEFT 7

ListNode *root = NULL;

typedef struct {
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
	pthread_mutex_t mutex;
} Controller;

void *buttons_reload(void *arg) {
	Controller *self = (Controller *)arg;
        struct js_event js;
        int ret = 0;
        while(1) {
                if(read(self->fd, &js, sizeof(struct js_event)) != sizeof(struct js_event)) {
                        perror("\ncontroller: error reading");
                        ret = 1;
                        pthread_exit(&ret);
                }
		pthread_mutex_lock(&self->mutex);
                switch(js.type & ~JS_EVENT_INIT) {
                case JS_EVENT_BUTTON:
                        self->button[js.number] = js.value;
                        break;
                case JS_EVENT_AXIS:
                        self->axis[js.number] = js.value;
                        break;
                }
		pthread_mutex_unlock(&self->mutex);
        }
        pthread_exit(&ret);
}

int initControl(char *filename) {
	Controller *controller;
	pthread_t thread;

	controller = (Controller *)malloc(sizeof(Controller));

	//Initialize
	controller->fd = open(filename, O_RDONLY);
	controller->axes = 2;
	controller->buttons = 2;
	controller->version = 0x000800;
	
	ioctl(controller->fd, JSIOCGVERSION, &controller->version);
        ioctl(controller->fd, JSIOCGAXES, &controller->axes);
        ioctl(controller->fd, JSIOCGBUTTONS, &controller->buttons);
        ioctl(controller->fd, JSIOCGNAME(NAME_LENGTH), controller->name);
        ioctl(controller->fd, JSIOCGAXMAP, controller->axmap);
        ioctl(controller->fd, JSIOCGBTNMAP, controller->btnmap);

	controller->button = calloc(controller->buttons, sizeof(char));
	controller->axis = calloc(controller->axes, sizeof(int));
	
	root = add_node(root, controller);

	pthread_create(&controller->thread, NULL, buttons_reload, controller);
	pthread_mutex_init(&controller->mutex, NULL);

	return controller->fd;
}

int compare(ListNode *this, ListNode *other) {
	Controller *cthis;
	Controller *cother;

	cthis = (Controller *)this->object;
	cother = (Controller *)other->object;

	return cthis->fd == cother->fd;
}

int readControl(int fd) {
	int result = 8;
	int *dir;
	int i;
	ListNode *tmpNode;
	Controller *tmpController;
	ListNode *node = (ListNode *)malloc(sizeof(ListNode));
	Controller *ctemp = (Controller *)malloc(sizeof(Controller));
	ctemp->fd = fd;
	node->object = ctemp;
	tmpNode = get_node(root, node, &compare);
	if(tmpNode == NULL) {
		free(ctemp);
		free(node);
		return -1;
	}
	free(ctemp);
	free(node);
	ctemp = tmpNode->object;
	pthread_mutex_lock(&ctemp->mutex);

	dir = malloc(sizeof(int) * 4);

	for(i = 0; i < 4; i++) {
		dir[i] = 0;
	}

	if(ctemp->button[4] ||(ctemp->axis[1] >= -32767 && ctemp->axis[1] < 0)){
		dir[0] = 1;
	}
	if(ctemp->button[6] ||(ctemp->axis[1] > 0 && ctemp->axis[1] <= 32767)){
		dir[2] = 1;
	}
	if(ctemp->button[5] ||(ctemp->axis[0] > 0 && ctemp->axis[0] <= 32767)){
		dir[1] = 1;
	}
	if(ctemp->button[7] ||(ctemp->axis[0] >= -32767 && ctemp->axis[0] < 0)){
		dir[3] = 1;
	}

	//printf("%d %d\n", ctemp->button[UP], ctemp->button[RIGHT]);

	if(dir[0] && dir[1]) {
		result = 1;
	} else if(dir[1] && dir[2]) {
		result = 3;
	} else if(dir[2] && dir[3]) {
		result = 5;
	} else if(dir[3] && dir[0]) {
		result = 7;
	} else if(dir[0]) {
		result = 0;
	} else if(dir[1]) {
		result = 2;
	} else if(dir[2]) {
		result = 4;
	} else if(dir[3]) {
		result = 6;
	} else {
		result = 8;
	}

	free(dir);
	pthread_mutex_unlock(&ctemp->mutex);
	return result;
}

