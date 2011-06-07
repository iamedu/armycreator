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

#include <mkescom/ipc.h>
#include <mkescom/sch.h>
#include <mkescom/queue.h>
#include <mkescom/process.h>

void write_reg(int pid, int reg, int value, int type) {
	MKNode *lroot = root;
	while( ((Process *) lroot->value)-> pid != pid )
		lroot = lroot->next;
	((Process *) lroot->value)->shared_regs[reg] = value;
	((Process *) lroot->value)->type[reg] = type;
	((Process *) lroot->value)->genesis[reg] = current_process();
	lroot = NULL;
	mkfree(lroot);
}

int read_reg(int reg) {
	int pid = current_process();
	int r_reg;
	MKNode *lroot = root;
	while( ((Process *) lroot->value)-> pid != pid )
		lroot = lroot->next;
	r_reg = ((Process *) lroot->value)->shared_regs[reg];
	lroot = NULL;
	mkfree(lroot);
	return r_reg;
}

int read_type(int reg) {
	int pid = current_process();
	int r_type;
	MKNode *lroot = root;
	while( ((Process *) lroot->value)-> pid != pid )
		lroot = lroot->next;
	r_type = ((Process *) lroot->value)->type[reg];
	lroot = NULL;
	mkfree(lroot);
	return r_type;
}

int read_genesis(int reg) {
	int pid = current_process();
	int r_genesis;
	MKNode *lroot = root;
	while( ((Process *) lroot->value)-> pid != pid )
		lroot = lroot->next;
	r_genesis = ((Process *) lroot->value)->genesis[reg];
	lroot = NULL;
	mkfree(lroot);
	return r_genesis;
}
