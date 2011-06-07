CFLAGS = -Iinclude -lpthread
#CC=arm-unknown-linux-gnu-gcc
CC=gcc

demo: list.o controller.o main.c lcd.o
	$(CC) -o demo main.c list.o lcd.o controller.o $(CFLAGS)

list.o: list.c
	$(CC) -c list.c $(CFLAGS)

controller.o: controller.c
	$(CC) -c controller.c $(CFLAGS)

lcd.o: lcd.c
	$(CC) -c lcd.c $(CFLAGS)

clean: 
	rm -r *.o demo

