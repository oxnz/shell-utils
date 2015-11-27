/*
 * Filename:	abspath.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-12-13 12:54:22 CST]
 * Last-update:	2014-12-13 12:54:22 CST
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
#include <limits.h>

int main(int argc, char *argv[]) {
	char resolved_path[PATH_MAX];
	int status = 0;
	int verbose = 0;

	if (argc < 2) {
		fprintf(stderr, "%s: missing oprand\n"
				"Try 'abspath --help' for more information.\n", *argv);
		return 1;
	}
	while (*++argv) {
		char* ret = realpath(*argv, resolved_path);
		if (NULL == ret) {
			if (verbose) {
				perror("realpath");
			}
			status = 1;
		} else {
			printf("%s\n", resolved_path);
		}
	}
	return status;
}
