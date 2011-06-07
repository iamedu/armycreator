#include <controller.h>

int initControl(char *filename) {
	int result = (int)filename;
	return result;
}

int readControl(int fd) {
	char *control;

	control = (char *)fd;

	return (*control);
}

