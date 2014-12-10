#!/usr/bin/env perl -w
# 
# ===============================================================
#
# Filename:	doc.pl
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-12-08 03:47:12 CST]
# Last-update:	2014-12-08 03:47:12 CST
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
# ===============================================================
#

use strict;
use warnings;

=pod

=encoding utf8

=head1 NAME

dotfm - dot files manager

=head1 SYNOPSIS

=head2 Options:

-pack <filename>
-update
-deploy
-help
man

=head1 OPTIONS

=over 8

=item B<-p --pack>
Pack dot-files to a tar.gz file

=item B<-u --update>
Update dot-files

=item B<-d --deploy>
Deploy dot-files to home directory

=item B<-h --help>
Print a brief help message and exits.

=back

=head1 DESCRIPTION

B<dotfm.pl> will read dot files under user's home directory and compare to the
specified directory, if differ, then copy to update.

=head1 BUGS

Bugs report address: L<https://github.com/oxnz/dot-files>

=cut
