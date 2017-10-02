#!/usr/bin/perl

use strict;
use warnings;
my $eleje;
my $vege;
my $reg;
my $m;
my $file = $ARGV[0];
open my $handle, $file or die "Could not open $file: $!";
my $sql = "fasta_proba.sql";
my $OUTFILE;
open $OUTFILE, ">$sql" or die "Error opening $sql: $!";


while( my $line = <$handle>)  {
    # fejléc
    if($.%2) {
        my $fejlec = $line;
        chop $fejlec;
        my @fields = split ':', $fejlec;
        $m = "'" . join("','", @fields) . "'";
        $reg = $fields[9];
        my @a=($reg=~/\(([0-9]+),([0-9]+)\)/g);
        $eleje = $a[0];
        $vege = pop @a;
        if (@a>2) {
            #print "multi primer";
        }
    } else {
        my $e = substr($line,$eleje-41,40);
        my $v = substr($line,$vege,40);
        my @a=($reg=~/\(([0-9]+,[0-9]+)\)/g);
        my $regio = join(" ",@a);
        # execute INSERT query
        # Print something into an output file
        print { $OUTFILE } "INSERT INTO fasta (\"H1\",\"H2\",\"H3\",\"H4\",\"H5\",\"H6\",\"H7\",\"H8\",\"H9\",\"H10\",\"regio\",\"eleje\",\"vege\") VALUES ($m,'$regio','$e','$v');\n" or die "Cannot write to $sql: $!";
    }
    # head-nX emulation for testing
    #last if $. == 200;
}
close $handle;
close $OUTFILE or warn "Cannot close $sql: $!";
