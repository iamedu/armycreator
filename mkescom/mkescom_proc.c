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

#include <mkescom/process.h>
#include <mkescom/mmg.h>

Process *init_process() {
	int i;
	static int pid = 0;
	Process *p = (Process *)mkmalloc( sizeof( Process ) );
	p->pid = pid;
	p->size = 543;
	p->executing = 0;
	for(i = 0; i < 32; i++) {
		p->shared_regs[i] = 0;
		p->type[i] = -1;
		p->genesis[i] = -1;
	}
	pid++;
	return p;
}
