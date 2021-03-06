#include <stdarg.h>

#define BASE 0
#define NULL 0

void put_char(char c);
void print_num(int d, int b);
int dprintf(const char *format, ...);
void *malloc(int);

typedef struct {
	int div;
	int mod;
} div_t;

typedef struct node {
	char n;
	struct node *next;
} node;

div_t div(int, int);
node *nodo(char);
void add(node **, char);

void main() {
	int i;
	int j;
	int *base = (void*)BASE;
	node *principal = NULL;
	node *tmp;
	*base = 4;

	for(i = 0; i < 10; i++) {
		add(&principal, 'a' + i);
	}
	add(&principal, '\n');

	tmp = principal;
	while(tmp != NULL) {
		dprintf("%c", tmp->n);
		tmp = tmp->next;
	}

	i = 530;
	j = 45;

	dprintf("Modulo %d\n", i % j);
	
	asm("bkpt");
}

void add(node **principal, char c) {
        node *tmp;
	tmp = *principal;
	if(*principal == NULL) {
		*principal = nodo(c);
	} else {
		while(tmp->next!= NULL) {
			tmp=tmp->next;
		}
		tmp->next = nodo(c);
	}
}


node *nodo(char c) {
        node *n = malloc(sizeof(node));
	n->n = c;
	n->next = NULL;
	return n;
}


void *malloc(int num) {
	int *base = (int*)BASE;
	void *ptr = (void *)*base;
	*base += num;
	return ptr;
}

div_t div(int d, int v) {
	int i;
	int count = 0;
	div_t res;
	for(i = 0; count < d; i++) {
		if((count + v) < d)
			count += v;
		else
			break;
	}

	res.div = i;
	res.mod = d - count;

	return res;
}

int dprintf(const char *format, ...) {
	va_list ap;
	char *fmt = (char *)format;
	int d;
	char c;
	char *s;

	va_start(ap, format);

	while(*fmt) {
		c = *fmt++;
		if(c != '%') {
			put_char(c);
			continue;
		}
		switch(*fmt++) {
			case 'd':
				d = va_arg(ap, int);
				print_num(d, 10);
				break;
			case 'x':
				d = va_arg(ap, int);
				print_num(d, 16);
				break;
			case 'c':
				d = va_arg(ap, int);
				put_char(d);
				break;
			case 's':
				s = va_arg(ap, char *);
				while(*s != '\0') {
					put_char(*s++);
				}
				break;
			case 'b':
				d = va_arg(ap, int);
				print_num(d, 2);
				break;
			case 'o':
				d = va_arg(ap, int);
				print_num(d, 8);
				break;
		}
	}

	va_end(ap);
	return 0;
}

void print_num(int d, int b) {
	div_t res;
	int quot;
	int tmp;
	int rem;
	char c;
	int i;
	char buf[32];


	i = 0;

	if(d & 0x80000000 && b == 10) {
		put_char('-');
		d = ~d;
		d += 1;
	}

	quot = d;

	do {
		tmp = quot;
		quot = tmp / b;
		rem  = tmp % b;
		if(rem >= 10) {
			c = rem + 'a' - 10;
		} else {
			c = '0' + rem;
		}
		buf[i++] = c;
	} while(quot != 0);

	while(i > 0) {
		put_char(buf[--i]);
	}
}

void put_char(char c) {
	char *ptr = (char *)0xfffff200;
	*ptr = c;
}

