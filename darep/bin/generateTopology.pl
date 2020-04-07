#!/usr/local/bin/perl
#
# Use perl5.26:
#  - on MacOSX use /opt/local/bin/perl5.26:
#      sudo ln -s /opt/local/bin/perl5.26 /usr/local/bin/perl
#  - on linux use perl installed from package or perl build from source:
#      sudo ln -s /usr/bin/perl /usr/local/bin/perl
#       or
#      sudo ln -s /usr/local/lib/perl-5.26.2/bin/perl /usr/local/bin/perl
#
# You can use same path /usr/local/bin/gawk on both systems, as follow:
#  - on MacOSX, add the symbolic link /usr/local/bin/gawk -> /sw/bin/awk, as follow:
#     cd /usr/local/bin; sudo ln -s /sw/bin/awk gawk
#  - on Linux, add the symbolic link /usr/local/bin/gawk -> /usr/bin/gawk, as follow:
#     cd /usr/local/bin; sudo ln -s /usr/bin/awk gawk

# set data
#######################
my $n="1000";# number of graph nodes

my $prob=0.2;# probability of adding an edge

my $howFar = 9;# how many removing steps

my $howMany = 100; # how many nodes remove in each step

# Script used to generate .xml topology file

use strict;
use warnings;
use feature 'say';
#use File::Spec; #  to get full path of the argument
use Path::Tiny; #  to get full path of the argument
use Getopt::Std; # to parse switches with arguments
use File::Touch; # touch command
use File::Cat; # cat command
use IO::Prompter; # to prompt message and read input
use File::Slurp qw( read_file write_file edit_file_lines ); #  Simple and Efficient Reading/Writing/Modifying of Complete Files
use Config; # to detect os type
use if ($^O eq 'linux'), 'Linux::Distribution' => qw(distribution_name distribution_version); # to detect a Linux distribution
use XML::LibXML::Reader; # to load big xml files, for which libxml fails
use XML::Normalize::LibXML qw(trim); # to remove whitespace occuring at beginning or end of string 
use File::Find::Rule; # to find all the subdirectories of a given directory that match a pattern
use File::Path qw(remove_tree); # to remove a list of directories
use Text::Xslate; # Template engine much faster than any other template engines.
use Text::Xslate::Syntax::Kolon; # Template engine, to use Kolon format
use XML::Entities; # Decode strings with XML entities (to decode special chars)
#use XML::LibXML::PrettyPrint 0.001 qw(print_xml);
use Sort::Naturally; # sort lexically, but sort numeral parts numerically

# work with random graphs
use Graph;
use Graph::Maker;
use Graph::Maker::Random;
use Graph::AdjacencyMatrix;

#use Config;
#my $osname = "$Config{osname}\n";
#my $osname = $^O;

use constant false => 0;
use constant true  => 1;

# OS type
my $OSTYPE = "$Config{osname}";
# set lib based on OS
my $LIB="lib";
# set lib based on OS
if ( $OSTYPE eq 'linux' && Linux::Distribution->new->distribution_name() eq 'suse' ) {
    $LIB="lib64";
}

# get the absolute and relative path of the script (relative path is based on the current directory)
my $MYPATH = path($0)->absolute;
my $MYRPATH = path($0)->relative;
# get the absolute and relative path of the directory where is the script (relative path is based on the current directory)
my $BIN = path($MYPATH)->parent;
my $RBIN = path($BIN)->relative;
my $MYNAME = path($MYPATH)->basename;

# where is all the stuff
# absolute path
my $BASEDIR=path($BIN)->parent(2); # bin/../../
# relative path (relative path is based on the current directory)
my $RBASEDIR=path($BASEDIR)->relative;

# directory where is darep
my $DAREPDIRNAME="darep";

# check BASEDIR: it is assumed that directory bin, where is this script, is located in ${BASEDIR}/${DAREPDIRNAME}
if ( ! -e "${BASEDIR}/${DAREPDIRNAME}/bin/${MYNAME}" ) {
    die "Ops! Base directory not correctly defined: ${BASEDIR}";
}

# debug info
#say STDERR "MYPATH: $MYPATH";
#say STDERR "\$0: $0";
#say STDERR "MYNAME: $MYNAME";
#say STDERR "BIN: $BIN";
#say STDERR "RBIN: $RBIN";
#say STDERR "MYPATH: $MYPATH";
#say STDERR "MYRPATH: $MYRPATH";
#say STDERR "BASEDIR: $BASEDIR";
#say STDERR "RBASEDIR: $RBASEDIR";

# darep directory
my $DAREP="${BASEDIR}/${DAREPDIRNAME}";
# input
my $INPUTPAR="${DAREP}/input";
# DAREP bin
my $DAREPBIN="${BIN}";

# project name
my $PROJECTNAME=path($BASEDIR)->basename;
# projects name
my $PROJECTSNAME=path($BASEDIR)->parent(1)->basename;
# absolute projects path
my $PROJECTS=path($BASEDIR)->parent(1);
# debug info
# say STDERR "PROJECTNAME: $PROJECTNAME";

my $INPUTTEMPLATES="${INPUTPAR}/templates"; # absolute path
my $LINPUTTEMPLATES="input/templates"; # path local to DAREP
# automatic input files, destination of automatic generated .xml file
my $INPUTAUTO="${INPUTPAR}/auto";
# .xml file extension
my $XMLEXT=".xml";

# templates xml
my $TXML="${LINPUTTEMPLATES}/caseStudy.tmpl";
my $TXMLMOBIUS26="${LINPUTTEMPLATES}/caseStudyMobius26.tmpl";

# help based on here document approach
sub help {
    my $message = qq{
      This script generates .xml topology file to feed darep in ${DAREP}/input/auto.
      The resulting file is automatically generated from the template ${DAREP}/input/templates/caseStudy.tmp.
      Don't modify manually the resulting .xml file, each manual change of this file will be overwritten by this script.
      To modify the resulting .xml file, change the template ${DAREP}/input/templates/caseStudy.tmp, then execute this script.
      Usage: $0 [-h] [-f]
            -f (optional argument): force script to answer yes to all prompts.
            -h (optional argument): help info.
        };
    print STDERR $message;
    exit 1
}


# find in the string the word-based position (from 0) of the word matching the input word
sub wpos {
    my ($word, $string) = @_;
    my $count=0;
    ++$count while $string =~ /(\S+)/g && $1 ne $word;
    return $count;
}
    
################## main #############################

# declare the darep command line flags/options we want to allow
my %options=();
if ( !getopts("hf", \%options) ) {
    help();
    die
}
my $fflag=false;
if ($options{h}) {
    help();
} elsif ($options{f}) {
    $fflag=true;
}
;

if ( @ARGV > 1 ) {
    say STDERR "Ops! Too many arguments!";
    help();
    exit 1
}

# automatically generated .xml file path
my $XMLDESTFILE="$INPUTAUTO/caseStudy";
my $XMLDESTFILEMOBIUS26="$INPUTAUTO/caseStudyMobius26";
# debug info
#say STDERR "XMLDESTFILE $XMLDESTFILE";
#say STDERR "XMLDESTFILE $XMLDESTFILEMOBIUS26";

# load templates
#######################

# templates files init
my $tx = Text::Xslate->new(
    path => $DAREP,
    cache_dir => "$ENV{HOME}/.xslate_cache",
    cache => 1,
    syntax => 'Text::Xslate::Syntax::Kolon',
    type => 'text'
    );

my $txMOBIUS26 = Text::Xslate->new(
    path => $DAREP,
    cache_dir => "$ENV{HOME}/.xslate_cacheMOBIUS26",
    cache => 1,
    syntax => 'Text::Xslate::Syntax::Kolon',
    type => 'text'
    );

# topology file for both 
# DARep with a script 
# and AdvancedRep
#######################

# load into a string the template file xml for DARep with a script
$tx->load_file($TXML);

# load into a string the template file xml for AdvancedRep
$txMOBIUS26->load_file($TXMLMOBIUS26);

# contruct random graph
#######################
my $g = new Graph::Maker('random', N => $n, PR => $prob, undirected => 1);

# beginloop
foreach my $r (0..$howFar) {

    my $remove = $howMany*$r;

    $g = $g->delete_vertices(($n-$remove)..$n);

    my $am = Graph::AdjacencyMatrix->new($g);

    my @neighbors = ();

    foreach my $i (0..$n-$remove-1) {
	my $count = 0;
	$neighbors[$i][$count]=$i;
	$count += 1;
	foreach my $j (0..$n-1){
	    my $u = $i + 1;
	    my $v = $j + 1;
	    if ($am->is_adjacent($u, $v)){
		$neighbors[$i][$count]=$j;
		$count += 1;
	    }
	}
    }

    # variables 
    my %vars_xml = (
	n => $n-$remove,
	neighbors => \@neighbors
	);

    # gen xml file for the topology
    write_file($XMLDESTFILE."_".$r.${XMLEXT}, $tx->render($TXML, \%vars_xml));

    say "*** Generated xml files:";
    say $XMLDESTFILE."_".$r.${XMLEXT};

    # gen xml file for the topology
    write_file($XMLDESTFILEMOBIUS26."_".$r.${XMLEXT}, $txMOBIUS26->render($TXMLMOBIUS26, \%vars_xml));

    say "*** Generated xml files:";
    say $XMLDESTFILEMOBIUS26."_".$r.${XMLEXT};

}
#endloop
