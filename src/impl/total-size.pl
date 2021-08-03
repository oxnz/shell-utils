#!/usr/bin/env perl -w
# 
#================================================================
#
# Filename:	total-size.pl
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2015-01-15 19:11:18 CST]
# Last-update:	2015-01-15 19:11:18 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License:
# Copyright (c) 2013 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
#====================================== [vim template v1.0] =====
#

use strict;
use warnings;

sub total_size {
	my ($top) = @_;
	my $size = -s $top;
	my $DIR;

	return $size if -f $top;
	unless (opendir $DIR, $top) {
		warn "Couldn't open directory $top: $!; skipping.\n";
		return $size;
	}

	my $file;
	while ($file = readdir $DIR) {
		next if $file eq '.' || $file eq '..';
		$size += total_size("$top/$file");
	}

	closedir $DIR;
	return $size;
}

print &total_size(".");
