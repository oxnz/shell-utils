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

int main(int argc, char *argv[]) {
	printf("%d\n", getpid());

	return 0;
}
