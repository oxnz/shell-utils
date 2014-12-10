/*
 * Filename:	killtopd.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-12-06 16:06:06 CST]
 * Last-update:	2014-12-06 16:06:06 CST
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


int help(FILE *outf) {
	fprintf(outf, "killtop -k [KEY] -v [VAL] -c [cmd]\n");
}

int main(int argc, char *argv[]) {
	while ((opt = getopt(argc, argv, "c:k:v:")) != -1) {
		switch (opt) {
			case 'n':
				flags = 1;
				break;
			case 't':
				nsecs = atoi(optarg);
				tfnd = 1;
				break;
			default: /* '?' */
				fprintf(stderr, "Usage: %s [-t nsecs] [-n] name\n",
						argv[0]);
				exit(EXIT_FAILURE);
		}
	}

	int pid = fork();
	if (pid < 0) {
		perror("fork");
		return -1;
	} else if (pid == 0) { /* child */
		return 1;
	}

	return 0;
}
