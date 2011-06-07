#ifndef _LCD_H
#define _LCD_H

typedef struct {
	int x;
	int y;
} Point;

typedef struct {
	int width;
	int height;
} Dimension;

int initLCD();
int createObject(int lcd, int id, int w, int h);
int move(int lcd, int id, int mid);
int setPosition(int lcd, int id, int x, int y);
int stopLCD(int lcd);
Point *getPosition(int lcd, int id);
Dimension *getDimensions(int lcd, int id);

#endif

