#!/usr/bin/perl
#
#       Perl Makefile for Test-Mockclass
#       $Id: Makefile.PL,v 1.1.1.1 2005/02/16 19:46:23 phaedrus Exp $
#
#	Invocation:
#		$ perl Makefile.PL                  # interactive behaviour
#		$ perl Makefile.PL --defaultdeps    # accept default value on prompts
#		$ perl Makefile.PL --checkdeps      # check only, no Makefile produced
#		$ perl Makefile.PL --skipdeps       # ignores all dependencies
#		$ perl Makefile.PL --testonly       # don't write installation targets
#
#	Then, to build:
#		$ make [all|test|install]           # install dependencies first
#		$ make checkdeps                    # same as the --checkdeps above
#		$ make installdeps                  # install dependencies only
#

# ExtUtils::AutoInstall Bootstrap Code, version 7.
BEGIN{my$p='ExtUtils::AutoInstall';my$v=0.45;$p->VERSION||0>=$v
or+eval"use $p $v;1"or+do{my$e=$ENV{PERL_EXTUTILS_AUTOINSTALL};
(!defined($e)||$e!~m/--(?:default|skip|testonly)/and-t STDIN or
eval"use ExtUtils::MakeMaker;WriteMakefile(PREREQ_PM=>{'$p',$v}
);1"and exit)and print"==> $p $v required. Install it from CP".
"AN? [Y/n] "and<STDIN>!~/^n/i and print"*** Installing $p\n"and
do{if (eval '$>' and lc(`sudo -V`) =~ /version/){system('sudo',
$^X,"-MCPANPLUS","-e","CPANPLUS::install $p");eval"use $p $v;1"
||system('sudo', $^X, "-MCPAN", "-e", "CPAN::install $p")}eval{
require CPANPLUS;CPANPLUS::install$p};eval"use $p $v;1"or eval{
require CPAN;CPAN::install$p};eval"use $p $v;1"||die"*** Please
manually install $p $v from cpan.org first...\n"}}}

use File::Find;

# the above handlers must be declared before the 'use' statement
use ExtUtils::AutoInstall (
						   
						   # required AutoInstall version
						   -version        => '0.40',

						   # core modules; may also be 'all'
						   -core           => {
											   Hook::WrapSub				=> 0.03,
											   Scalar::Util	   				=> 1.14,
	                                           Test::SimpleUnit				=> 1.21,
	                                           Tie::Watch				    => 1.1,
						   },
	);

# Build a custom list of modules to install. This is because the parser module
# generation happens because it's a target, so it doesn't exist before the
# PM list is generated
my %pm = ();


File::Find::find(
	sub {
		if (/\.pm$/s) {
			my $name = "$File::Find::dir/$_";
			print "Adding: $_ => $name\n";
			($pm{$name} = $name) =~ s{lib/}{\$(INST_LIBDIR)/}
		}
	}, "lib" );

WriteMakefile(
			  NAME				=> 'MockClass',
			  DISTNAME			=> 'Test-MockClass',
			  VERSION_FROM		=> 'lib/Test/MockClass.pm',
			  AUTHOR			=> 'Jeremiah Jordan <jjordan@perlreason.com>',
			  ABSTRACT			=> 'A class to create mock classes and object for testing purposes',
			  PM				=> \%pm,
			  dist			=> {
								TARFLAGS		=> 'cvf',
								CI				=> "cvs commit",
								RCS_LABEL		=> 'cvs tag r$(VERSION_SYM)',
								SUFFIX			=> ".gz",
								DIST_CP         => 'ln',
								DIST_DEFAULT	=> 'all tardist',
								COMPRESS		=> "gzip",
							   },
			  clean			=> { FILES	=> "*.tar.bz2 *.tar.gz" },
			 );
