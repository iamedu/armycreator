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

#ifndef _MKESCOM_IPC_H
#define _MKESCOM_IPC_H

#include <mkescom/queue.h>

#define REG_TYPE_PLAIN 0
#define NULL 0

extern MKNode *root;

void write_reg(int pid, int reg, int value, int type);
int read_reg(int reg);
int read_type(int reg);
int read_genesis(int reg);

#endif

