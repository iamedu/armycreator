#include <lcd.h>

#define LCD_BASE 4294963716

Point p[3];
Dimension d[3];

int initLCD() {
	return LCD_BASE;
}

int createObject(int lcd, int id, int w, int h) {
	int *plcd = (int *)lcd;
	int *presult = (int *)(lcd + 16);
	int result;

	*(plcd + 1) = w;	
	*(plcd + 2) = w;	
	*(plcd + 3) = id;	
	*(plcd + 0) = 1;
	
	while((result = *presult) == 0);
	*presult = 0;

	return result;
}

int move(int lcd, int id, int mid) {
	int *rlcd = (int *)lcd;
	
	*(rlcd + 1) = id;
	*(rlcd + 2) = mid;
	*(rlcd + 3) = mid;
	*(rlcd + 0) = 2;


}

Point *getPosition(int lcd, int id) {
	int *rlcd = (int *)lcd;
	int *presult = (int *)(lcd + 16);	
	int i = 0;
	*(rlcd + 1) = id;
	*(rlcd + 2) = 0;
	*(rlcd + 3) = 0;
	*(rlcd + 0) = 3;

	while(i++ < 200);

	p[id - 2].x = *(presult + 0);
	p[id - 2].y = *(presult + 1);

	return &p[id - 2];
}

int setPosition(int lcd, int id, int x, int y) {
	int *rlcd = (int *)lcd;
	int *presult = (int *)(lcd + 16);	
	int i = 0;
	*(rlcd + 1) = id;
	*(rlcd + 2) = x;
	*(rlcd + 3) = y;
	*(rlcd + 0) = 4;
}

Dimension *getDimensions(int lcd, int id) {
	int *rlcd = (int *)lcd;
	int *presult = (int *)(lcd + 16);	
	int i = 0;
	*(rlcd + 1) = id;
	*(rlcd + 2) = 0;
	*(rlcd + 3) = 0;
	*(rlcd + 0) = 5;

	while(i++ < 200);

	d[id - 2].width = *(presult + 0);
	d[id - 2].height = *(presult + 1);

	return &d[id - 2];
}

int stopLCD(int lcd) {
}

