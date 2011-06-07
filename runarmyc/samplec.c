char createObject(unsigned char *lcd, char id, char x, char y) {
	char *rlcd = (char *)lcd;
	int *presult = (int *)(lcd + 4);
	int result;
	*(rlcd + 1) = x;
	*(rlcd + 2) = y;
	*(rlcd + 3) = id;
	*(rlcd + 0) = 1;
	while((result = *presult) == 0);
	*presult = 0;
	return result;
}

void getPosition(unsigned char *lcd, char id, int *x, int *y) {
	char *rlcd = (char *)lcd;
	*(rlcd + 1) = id;
	*(rlcd + 0) = 3;
	int *presult = (int *)(lcd + 4);
	*x = *presult;
	*y = *(presult + 1);
}

void move(unsigned char *lcd, char id, char x, char y) {
	char *rlcd = (char *)lcd;
	*(rlcd + 1) = id;
	*(rlcd + 2) = x;
	*(rlcd + 3) = y;
	*(rlcd + 0) = 2; //Manda comando
}

void setPosition(unsigned char *lcd, int id, int x, int y) {
	char *rlcd = (char *)lcd;
	*(rlcd + 1) = id;
	*(rlcd + 2) = x;
	*(rlcd + 3) = y;
	*(rlcd + 0) = 4;
}

void getDimensions(unsigned char *lcd, int id, int *w, int *h) {
	char *rlcd = (char *)lcd;
	*(rlcd + 1) = id;
	*(rlcd + 0) = 5;
	int *presult = (int *)(lcd + 4);
	*w = *presult;
	*h = *(presult + 1);
}

char readControl(unsigned char *control) {
	char result;
	result = *control;
	if(result < 0 || result > 7) {
		result = 8;
	}
	return result;
}

void put_char(char c) {
	char *ptr = (char *)0xfffff200;
	*ptr = c;
}

void main() {
	unsigned char *lcd = (unsigned char *)4294963716;
	unsigned char *control1 = (unsigned char *)8587830276;
	unsigned char *control2 = (unsigned char *)8587830272;
	int i;
	char id1;
	char id2;
	char move1;
	char move2;
	int x;
	int y;
	id1 = createObject(lcd, 1, 0, 0);
	id2 = createObject(lcd, 2, 0, 0);
	put_char('0' + id1);
	put_char(' ');
	put_char('0' + id2);
	put_char('\n');
	while(1) {
		move1 = readControl(control1);
		move2 = readControl(control2);

		getPosition(lcd, id1, &x, &y);

		if(x >= 0 && x < 10) {
			put_char('0' + x);
		}
		put_char(' ');
		if(y >= 0 && y < 10) {
			put_char('0' + y);
		}
		put_char('\n');

		if(move1 != 8)
			move(lcd, id1, readControl(control1), 1);

		for(i = 0; i < 1000; i++);

		if(move2 != 8)
			move(lcd, id2, readControl(control2), 1);
	}
}
