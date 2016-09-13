/*
 * Filename:	sigecho.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2015-11-29 18:10:00 CST]
 * Last-update:	2015-11-29 18:10:00 CST
 * Description: anchor
 *
 * Version:		0.0.1
 * Revision:	[NONE]
 * Revision history:	[NONE]
 * Date Author Remarks:	[NONE]
 *
 * License: 
 * Copyright (c) 2013 Oxnz
 *
 * Distributed under terms of the [LICENSE] license.
 * [license]
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <err.h>

void sig_handler(int signo) {
	printf("signal received:[%d]\n", signo);
	sleep(10);
}

int main(int argc, char *argv[]) {
	struct sigaction sigact;
	sigact.sa_handler = sig_handler;
	int sigs[] = {SIGINT, SIGTERM, SIGHUP};
	int i;
	for (i = 0; i < sizeof(sigs)/sizeof(sigs[0]); ++i) {
		if (sigaction(sigs[i], &sigact, NULL) == -1) {
			perror("sigaction");
			return 1;
		}
	}

	for (i = 0; i < 3; ++i) {
		sleep(100);
	}

	return 0;
}
