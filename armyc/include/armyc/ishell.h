#ifndef _ARMYC_ISHELL_H
#define _ARMYC_ISHELL_H

#import <armyc/ARMCore.h>

struct arguments {
	char *args[1];
	char *config;
	char *script;
	char *debug;
	char *exec;
};

typedef struct {
	struct arguments *args;
	ARMCore *core;
} shell_thread_args;

#endif

