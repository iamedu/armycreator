/*
 * This file is part of mkescom.
 * 
 * mkescom is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * mkescom is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with mkescom.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _MKESCOM_PROCESS_H
#define _MKESCOM_PROCESS_H

typedef struct {
	int pid;
	int code_seg;
	int stack_seg;
	int data_seg;
	int size;
	int curr_inst_addr;

	/* Checks if process is being executed */
	int executing;

	/* The next variables define the state of the process */
	int regs[16];
	int cpsr;

	/* IPC variables */
	int shared_regs[32]; //Initialized to 0
	int type[32]; //Type of the shared reg generator initialized to -1
	int genesis[32]; //PID of the shared reg generator intialized to -1
} Process;

Process *init_process();

#endif

