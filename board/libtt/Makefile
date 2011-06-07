CC=arm-unknown-linux-gnu-gcc
FREAD=/home/iamedu/Projects/armyc/armdev/tt/EL_FREAD/fread

samplec: samplec.out
	$(FREAD) samplec.out samplec

samplec.out: samplec.s init.s controller.s lcd.s
	$(CC) -nostdlib init.s samplec.s controller.s lcd.s -o samplec.out -lgcc

samplec.s: samplec.c
	$(CC) -S samplec.c -o samplec.s -Iinclude

controller.s: controller.c
	$(CC) -S controller.c -o controller.s -Iinclude

lcd.s: lcd.c
	$(CC) -S lcd.c -o lcd.s -Iinclude

clean:
	rm samplec.s samplec.out samplec

