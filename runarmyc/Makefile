all: sample samplec

samplec: samplec.out
	/home/iamedu/Projects/armyc/armdev/tt/EL_FREAD/fread samplec.out samplec

samplec.out: samplec.s init.s
	arm-unknown-linux-gnu-gcc -nostdlib init.s samplec.s -o samplec.out -lgcc

samplec.s: samplec.c
	arm-unknown-linux-gnu-gcc -S samplec.c -o samplec.s

sample:	sample.out
	arm-unknown-linux-gnu-objcopy -O binary sample.out sample

sample.out: sample.s 
	arm-unknown-linux-gnu-gcc -nostdlib sample.s -o sample.out

clean: 
	rm *.log *.out samplec samplec.s sample
