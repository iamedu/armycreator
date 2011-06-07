#import <Chiles/Utils.h>
#import <stdarg.h>
#import <stdlib.h>

void ChPrint(ChString *fmt, ...) {
	va_list ap;
	va_start(ap, fmt);
	ChFLPrint(stdout, fmt, ap);
	va_end(ap);
}

void ChFLPrint(FILE *f, ChString *fmt, va_list ap) {
	char c;
	int i;

	//Types
	int d;
	ChObject *obj;
	ChString *str;
	char *cstr;

	for(i = 0; i < [fmt length]; i++) {
		c = [fmt cString][i];
		if(c == '%') {
			c = [fmt cString][++i];
			switch(c) {
				case '@':
					obj = va_arg(ap, id);
					if(obj != nil) {
						str = [obj description];
						fprintf(f, "%s", [str cString]);
					} else {
						fprintf(f, "(nil)");
					}
					break;
				case 's':
					cstr = va_arg(ap, char *);
					fprintf(f, "%s", cstr);
					break;
				case 'd':
					d = va_arg(ap, int);
					fprintf(f, "%d", d);
					break;
				case 'x':
					d = va_arg(ap, int);
					fprintf(f, "%x", d);
					break;
				case 'c':
					d = va_arg(ap, int);
					fprintf(f, "%c", d);
					break;
			}
		} else {
			fprintf(f, "%c", c);
		}
	}

}

