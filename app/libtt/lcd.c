#include <lcd.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>

#define buflen 512
#define HOSTNAME "127.0.0.1"
unsigned int portno = 1234;

typedef struct {
	char operation;
	char op1;
	char op2;
	char op3;
} LCDMessage;

typedef struct {
	int res1;
	int res2;
} LCDResult;

int initLCD() {
	int sd = socket(AF_INET, SOCK_STREAM, 0);

	struct sockaddr_in sin;
	struct hostent *host = gethostbyname(HOSTNAME);
	char buf[buflen];
	int len;

	memcpy(&sin.sin_addr.s_addr, host->h_addr, host->h_length);
	sin.sin_family = AF_INET;
	sin.sin_port = htons(portno);

	if (connect(sd, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
		perror("Connecting");
		exit(1);
	}

	return sd;
}

int stopLCD(int lcd) {
	return close(lcd);
}

int createObject(int lcd, int id, int x, int y) {
	LCDMessage *message = malloc(sizeof(LCDMessage));
	LCDResult *result = malloc(sizeof(LCDResult));
	int res;

	message->operation = 1;
	message->op1 = x;
	message->op2 = y;
	message->op3 = id;

	send(lcd, message, sizeof(LCDMessage), 0);
	recv(lcd, result, sizeof(LCDResult), 0);

        res = result->res1;

        free(result);
	free(message);
	return res;
}

int move(int lcd, int id, int mid) {
	LCDMessage *message = malloc(sizeof(LCDMessage));

	message->operation = 2;
	message->op1 = id;
	message->op2 = mid;
	message->op3 = 0;
	
	send(lcd, message, sizeof(LCDMessage), 0);

	free(message);
	
	usleep(1000);

	return 1;
}

int setPosition(int lcd, int id, int x, int y) {
	LCDMessage *message = malloc(sizeof(LCDMessage));

	message->operation = 4;
	message->op1 = id;
	message->op2 = x;
	message->op3 = y;

	send(lcd, message, sizeof(LCDMessage), 0);

	free(message);

	usleep(1000);

	return 1;
}

Point *getPosition(int lcd, int id) {
	LCDMessage *message = malloc(sizeof(LCDMessage));
	LCDResult *result = malloc(sizeof(LCDResult));
	Point *point = malloc(sizeof(Point));
	message->operation = 3;
	message->op1 = id;

	send(lcd, message, sizeof(LCDMessage), 0);
	recv(lcd, result, sizeof(LCDResult), 0);

	point->x = result->res1;
	point->y = result->res2;

	free(message);
	free(result);

	return point;
}

Dimension *getDimensions(int lcd, int id) {
	LCDMessage *message = malloc(sizeof(LCDMessage));
	LCDResult *result = malloc(sizeof(LCDResult));
	Dimension *dimensions = malloc(sizeof(Dimension));
	message->operation = 5;
	message->op1 = id;

	send(lcd, message, sizeof(LCDMessage), 0);
	recv(lcd, result, sizeof(LCDResult), 0);

	dimensions->width = result->res1;
	dimensions->height = result->res2;

	free(message);
	free(result);

	return dimensions;
	
}
