shc: main.o mkescom_mmg.o mkescom_proc.o mkescom_queue.o mkescom_sch.o mkescom_ipc.o
	gcc -o shc main.o mkescom_mmg.o mkescom_proc.o mkescom_queue.o mkescom_sch.o mkescom_ipc.o

main.o: main.c
	gcc -c main.c -Iinclude -Werror

mkescom_ipc.o: mkescom_ipc.c
	gcc -c mkescom_ipc.c -Iinclude

mkescom_sch.o: mkescom_sch.c
	gcc -c mkescom_sch.c -Iinclude

mkescom_proc.o: mkescom_proc.c
	gcc -c mkescom_proc.c -Iinclude

mkescom_queue.o: mkescom_queue.c
	gcc -c mkescom_queue.c -Iinclude

mkescom_mmg.o: mkescom_mmg.c
	gcc -c mkescom_mmg.c -Iinclude

clean:
	rm *.o shc
