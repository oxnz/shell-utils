/*
 * Filename:	getpid.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		2015-11-29 19:42:43 CST
 * Last-update:	2015-11-29 19:42:43 CST
 * Description: anchor
 *
 * Version:		0.0.1
 * Revision:	[NONE]
 * Revision history:	[NONE]
 * Date Author Remarks:	[NONE]
 *
 * License:
 * Copyright (c) 2015 Oxnz
 *
 * Distributed under terms of the [LICENSE] license.
 * [license]
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static void usage(FILE *fp, const char *prog);

int main(int argc, char *argv[]) {
	int c;
	while ((c = getopt(argc, argv, "hg")) != -1) {
		switch (c) {
			case 'h':
				usage(stdout, *argv);
				return 0;
			case 'g':
				printf("%d %d\n", getpid(), getppid());
				return 0;
			default:
				return 1;
		}
	}
	printf("%d\n", getpid());

	return 0;
}

static void usage(FILE *fp, const char *prog) {
	fprintf(fp, "Usage: %s -[h|g]\n", prog);
}
