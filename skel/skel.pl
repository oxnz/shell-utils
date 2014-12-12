#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec::Functions qw/rel2abs/;
use File::Basename;
use POSIX qw/strftime/;
use Data::Dumper;

# version: major minor patch release
my @VERSION	= qw/1 0 1 alpha/;

{
	# sub command closure
	my $instpath;
	my $verbose	= 0;
	my $logfile;

	INIT {
		$instpath = dirname(dirname(rel2abs($0)))
			or die("cannot find install path\n");
		open($logfile, '>>:encoding(UTF-8)', "$instpath/var/log/skel.log")
			or die("cannot open logfile [$logfile]: $!\n");
	}

	END {
		close($logfile) or die("cannot close logfile [$logfile]: $!\n");
	}

	# signal handler
	sub onsig {
		my ($sig) = @_;
		print STDERR "caught signal: $sig --exiting\n";
		close($logfile);
		exit(1);
	}

	sub skellog {
		my $argc = @_;
		die("2 arguments expected, but $argc found") unless 2 == $argc;
		my ($level, $msg) = @_;
		$level = lc $level;
		$msg = strftime('%F %T %Z', localtime) . " [$level] " . join(':', caller) . ": $msg\n";
		if ($level eq 'debug') {
		} elsif ($level eq 'info') {
		} elsif ($level eq 'warning') {
		} elsif ($level eq 'error') {
		} else {
			die "invalid log level: $level";
		}
		print $msg;
		print $logfile $msg;
	}

	#	if ! INSTPATH="$(dirname "$(dirname "$(pwd)/$0")")"; then
	#		echo "error: cannot find install path" >&2
	#		return 1
	#	else
	#		LOGFILE="${INSTPATH}/var/log/skel.log"
	#	fi
	#	msgdump 'error' 'hello'
	#	#${opt} "$@"
	sub update {
		if (not chdir $instpath) {
			skellog 'error', "cannot chdir to [$instpath]";
			die("cannot chdir to \$instpath($instpath)\n");
		}
		my $cmd = 'git pull --rebase --stat origin master';
		print "updating...\n";
		if (system($cmd) != 0) {
			skellog 'error', "failed to execute command: [$cmd], return value: [$?]";
			die("command $cmd failed\n");
		}
		print "success\n";
	}
} # end of sub command closure

#sub main() {
binmode STDOUT, ':encoding(UTF-8)';
push @ARGV, '--help' if 0 == @ARGV;
my $opt = shift @ARGV;
my %optstubs = (
	'--verbose'	=> sub {
		die("this option is unimplemented yet\n");
	},
	'--version'	=> sub {
		my $release = pop @VERSION;
		print "skel ($^O) " . join('.', @VERSION) . "-$release\n";
		print "Copyright (C) 2014 The shell-utils project developers\n";
	},
	'--help'	=> sub {
		use Pod::Usage;
		&pod2usage( { verbose => 1, exitval => 0 });
	},
	'--man'		=> sub {
		&pod2usage( { verbose => 2, exitval => 0 });
	},
	'update'	=> sub { &update; },
);

my $stub = $optstubs{$opt} or sub {
	if ($opt =~ /^\w+$/) {
		print STDERR "invalid sub command: [$opt]\ntry '$0 --help' to see usage\n";
	} else {
		print STDERR "invalid option: [$opt]\ntry '$0 --help' to see usage\n";
	}
	exit 1;
}->();
$SIG{'INT'} = \&onsig;
skellog 'error', 'hello';
$stub->(@ARGV);
#} end of sub main

__END__

=pod

=encoding utf8

=head1 NAME

     _        _      _              
    | |      | |    | |             
 ___| | _____| | ___| |_ ___  _ __  
/ __| |/ / _ \ |/ _ \ __/ _ \| '_ \ 
\__ \   <  __/ |  __/ || (_) | | | |
|___/_|\_\___|_|\___|\__\___/|_| |_|
------------------------------------
     skeleton package manager
------------------------------------

=head1 SYNOPSIS

skel help command

skel [options] install|update

skel --help|--man|--verbose|--version

=head1 OPTIONS

=over

=item B<--help>

show this help message and exit

=item B<help command>

display help information for the specified command

=item B<--man>

display man page for skel

=item B<update>

update shell-utils

=item B<--verbose>

enable verbose output

=item B<--version>

show version information

=back

=head1 DESCRIPTION

skel (abbr. sleleton) is the shell-utils package manager

=cut
