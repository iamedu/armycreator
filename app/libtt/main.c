#include <controller.h>
#include <lcd.h>

int main() {
	int c1 = initControl("/dev/input/js0");
	int c2 = initControl("/dev/input/js1");
	int o1;
	int o2;
	int o3;
	int o4;
	int o5;
	int lcd = initLCD();
	int read1;
	int read2;
	int vidas1 = 3;
	int vidas2 = 3;
	int dir = 3;
	int i = 0;
	Point *p1;
	Point *p2;
	Point *p3;
	Dimension *dim1;
	Dimension *dim2;
	Dimension *dim3;

	o4 = createObject(lcd, 4, 0, 0);
	o1 = createObject(lcd, 1, 60, 0);
	o2 = createObject(lcd, 2, 250, 0);
	o3 = createObject(lcd, 3, 0, 0);
	

	dim1 = getDimensions(lcd,o1);
	dim2 = getDimensions(lcd,o2);
	dim3 = getDimensions(lcd,o3);
	setPosition(lcd,o1,60,130-dim1->height);
	setPosition(lcd,o2,250,130-dim2->height);

	while(1) {
		read1 = readControl(c1);
		read2 = readControl(c2);
		if(read1 == 0 || read1 == 4) {
			move(lcd, o1, read1);
		}
		if(read2 == 0 || read2 == 4) {
			move(lcd, o2, read2);
		}
		

		move(lcd, o3, dir);
		p3 = getPosition(lcd, o3);
		p1 = getPosition(lcd, o1);
		p2 = getPosition(lcd, o2);
		
		if(dir == 5 || dir == 7)
		{
			if(((p3->x >=((p1->x + dim1->width)-8)) && (p3->x < ((p1->x + dim1->width)+4))) && ((p3->y >= (p1->y -12)) && (p3->y < (p1->y +(dim1->height/2)))))
				dir = 1;
			if(((p3->x >=((p1->x + dim1->width)-8)) && (p3->x < ((p1->x + dim1->width)+4))) && ((p3->y >= (p1->y +(dim1->height/2))) && (p3->y < (p1->y + dim1->height + 8))))
				dir = 3;
			if (p3->x <= 0)
			{
				vidas1--;
				if(vidas1 == 0)
				{
					
					o5 = createObject(lcd, 5, 80, 110);
					break;
				}
				if(dir == 5)
					dir = 3;
				else
					dir = 1;
			}
			
		}
		else {
			//aqui es cuando dir == 3  || dir == 1
			if((((p3->x + dim3->width) < (p2->x + 8)) && ((p3->x + dim3->width) >= (p2->x - 4))) && ((p3->y >= (p2->y - 12)) && (p3->y < (p2->y +(dim2->height/2)))))
				dir = 7;
			if((((p3->x + dim3->width) < (p2->x + 8)) && ((p3->x + dim3->width) >= (p2->x - 4))) && ((p3->y >= (p2->y +(dim2->height/2))) && (p3->y < (p2->y + dim2->height + 8))))
				dir = 5;
			if((p3->x + dim3->width) >= 320)
			{
				vidas2--;
				if(vidas2 == 0)
				{
					o5 = createObject(lcd, 5, 80, 110);
					break;
				}
				if(dir == 3)
					dir = 5;
				else
					dir = 7;
			}
		}
		
		//Validar bordes superior e inferior
		if((p3->y + dim3->height) >= 240)
		{
			if(dir == 3)
				dir = 1;
			else 
				dir = 7; 
		}
		if(p3->y <= 0)
		{
			if(dir == 7)
				dir = 5;
			else
				dir = 3;
		}
		

		//printf("%u %u\n", p3->x, p3->y);
		//printf("%u %u\n", p2->x, p2->y);
	}

	stopLCD(lcd);

	return 0;
}

