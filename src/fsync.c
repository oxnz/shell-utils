/*
 * Filename:	fsync.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		2015-09-04 20:06:36 CST
 * Last-update:	2015-09-04 20:06:36 CST
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

#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sysexits.h>
#include <unistd.h>

static void usage(void);

int main(int argc, char *argv[]) {
	int fd;
	int i;
	int rv;

	if (argc < 2) {
		usage();
		/* NOT REACHED */
	}

	rv = EX_OK;
	for (i = 1; i < argc; ++i) {
		if (-1 == (fd = open(argv[i], O_RDONLY))) {
			warn("open %s", argv[i]);
			if (EX_OK == rv) {
				rv = EX_NOINPUT;
			}
			continue;
		}

		if (-1 == fsync(fd)) {
			warn("fsync %s", argv[i]);
			if (EX_OK == rv)
				rv = EX_OSERR;
		}
		close(fd);
	}
	return rv;
	/* NOT REACHED */
}

static void usage(void) {
	fprintf(stderr, "usage: fsync file ...\n");
	exit(EX_USAGE);
	/* NOT REACHED */
}
