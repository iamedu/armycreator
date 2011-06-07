#import <argp.h>
#import <stdlib.h>
#import <string.h>
#import <config.h>
#import <pthread.h>
#import <dlfcn.h>

#import <armyc/python.h>
#import <armyc/ishell.h>
#import <armyc/ARMDevice.h>
#import <armyc/ARMPythonDevice.h>
#import <Chiles/ChString.h>
#import <Chiles/ChConf.h>
#import <Chiles/ChArray.h>

const char *argp_program_version =
    PACKAGE_STRING;

const char *argp_program_bug_address =
    PACKAGE_BUGREPORT;

static char doc[] =
    "ARMyC is an arm simulator creator with it you can simulate almost every ARM hardware part you want";

static char args_doc[] = "";

static struct argp_option options[] = {
        {"config",  'c', "armyc.conf",      0,  "Config file, the default value is armyc.conf" },
        {"script",  's', "script.py",      0,  "Python script to load" },
        {"elog",  'e', "exec.log",      0,  "Execution log, prints ARM instructions as they are executed" },
        {"dlog",  'd', "debug.log",      0,  "Debug log, prints debug information" },
        { 0 }
};

static error_t parse_opt (int, char *, struct argp_state *);

static struct argp argp = {options, parse_opt, args_doc, doc};


static error_t parse_opt (int key, char *arg, struct argp_state *state) {
	struct arguments *arguments = state->input;

	switch (key) {
		case 'd':
			arguments->debug = arg;
			break;
		case 'e':
			arguments->exec = arg;
			break;
		case 's':
			arguments->script = arg;
			break;
		case 'c':
			arguments->config = arg;
			break;
		case ARGP_KEY_ARG:
			if (state->arg_num >= 1) {
				argp_usage(state);
			}
			arguments->args[state->arg_num] = arg;
			break;
		default:
			return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

void start_shell(shell_thread_args *args) {
	ishell(args->args, args->core);
}

ARMCore *configure_core(struct arguments *args) {
	void *handle;
	char *error;
	UWord base;
	UWord addr;
	ARMCore *core;
	ARMDevice *(*get_dev)(UWord, ARMCore *, ChString *, ChConf*);
	ChList *(*get_insts)();
	ARMDevice *dev;
	ChArray *devices;
	ChArray *programs;
	ChString *deviceName;
	ChString *programName;
	ChString *programFile;
	ChString *libName;
	ChString *instsLibName;
	ChString *symName;
	ChString *tmpString;
	ChString *model;
	ChString *dlog = NULL;
	ChString *elog = NULL;
	FILE *program;
	int i;
	UByte inst;
	ChString *confPath = [[ChInmutableString alloc]
		                                initWithCString:args->config];
	ChConf *conf = [[ChConf alloc] initWithFilename:confPath];
	
	if(args->debug != NULL) {
		dlog = [[ChInmutableString alloc] initWithCString:args->debug];
	}
	if(args->exec != NULL) {
		elog = [[ChInmutableString alloc] initWithCString:args->exec];
	}

	core = [[ARMCore alloc] initWithConf:conf
	                        withElog:elog
				withDlog:dlog];
	tmpString = [conf get:@"devices" at:@"armyc"];

	devices = [tmpString split:@","];

	for(i = 0; i < [devices length]; i++) {
		deviceName = (ChString *)[devices get:i];
		tmpString = [conf get:@"lib" at:deviceName];
		model = [conf get:@"model" at:deviceName];
		libName = @"lib";
		libName = [libName concat:tmpString];
		libName = [libName concat:@".so"];
		symName = [conf get:@"sym" at:deviceName];
		tmpString = [conf get:@"base" at:deviceName];
		base = [tmpString toInt];

		if([@"objc" isEqual:model]) {
			handle = dlopen([libName cString], RTLD_LAZY);
			if (!handle) {
				fprintf (stderr, "%s\n", dlerror());
				exit(1);
			}
			get_dev = dlsym(handle, [symName cString]);
			if ((error = dlerror()) != NULL)  {
				fprintf (stderr, "%s\n", error);
				exit(1);
			}
			dev = (*get_dev)(base, core, deviceName, conf);
		} else {
			dev = [[ARMPythonDevice alloc]
			       initWithCore:core
			           withBase:base
			           withConf:conf
				   withName:deviceName];
		}
		[dev run];
	}


	tmpString = [conf get:@"programs" at:@"armyc"];
	programs = [tmpString split:@","];
	for(i = 0; i < [programs length]; i++) {
		programName = (ChString *)[programs get:i];
		programFile = [conf get:@"file" at:programName];
		tmpString = [conf get:@"loadat" at:programName];
		addr = [tmpString toInt];

		program = fopen([programFile cString], "r");

		if(program == NULL) {
			perror([programFile cString]);
			exit(1);
		}

		while(fread(&inst, 1, 1, program) > 0) {
			[core writeByte:inst at:addr];
			addr++;
		}

		fclose(program);
	}

	instsLibName = [conf get:@"instructions" at:@"armyc"];

	handle = dlopen([libName cString], RTLD_LAZY);
	if (!handle) {
		fprintf (stderr, "instructions dlopen: %s\n", dlerror());
		exit(1);
	}
	get_insts = dlsym(handle, "instructions");
	if ((error = dlerror()) != NULL)  {
		fprintf (stderr, "instructions dlsym: %s\n", error);
		exit(1);
	}
	[core setInstructions:(ChList *)(*get_insts)()];

	return core;
}

int main(int argc, char **argv) {
	int i;
	ARMCore *core;
	struct arguments arguments;
	shell_thread_args args;
	FILE *tmpFile;
	pthread_t shell_thread;

	int baseAddr;
	int size;

	arguments.script = NULL;
	arguments.config = NULL;
	arguments.debug  = NULL;
	arguments.exec   = NULL;


	argp_parse (&argp, argc, argv, 0, 0, &arguments);


	if(arguments.config == NULL) {
		arguments.config = malloc(11);
		strcpy(arguments.config, "armyc.conf");
	}

	tmpFile = fopen(arguments.config, "r");
	if(tmpFile == NULL) {
		perror(arguments.config);
		exit(1);
	}
	fclose(tmpFile);
	
	Py_Initialize();

	setup_python(&arguments);
	core = configure_core(&arguments);
	args.args = &arguments;
	args.core = core;
	


	[core start];

	start_shell(&args);

	Py_Finalize();

	return 0;
}

