/*
 * Filename:	params.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-11-30 23:03:25 CST]
 * Last-update:	2014-11-30 23:03:25 CST
 * Description: display parameters
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

int main(int argc, char *argv[]) {
	int i = 0;
	for (; i < argc; ++i) {
		printf("argv[%d] = [%s]\n", i, argv[i]);
	}

	return 0;
}
