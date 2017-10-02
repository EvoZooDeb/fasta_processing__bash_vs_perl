#!/usr/bin/perl

use strict;
use warnings;
my $eleje;
my $vege;
my $reg;
my $m;
my $ssr_szam;
my $motivum;
my $repeat;
my $file = $ARGV[0];
open my $handle, $file or die "Could not open $file: $!";
my $sql = "fasta_2.sql";
my $OUTFILE;
open $OUTFILE, ">$sql" or die "Error opening $sql: $!";

use DBI;
# connect
my $dbh = DBI->connect("DBI:Pg:dbname=fasta;host=localhost", "gisadmin", "Koo3aico", {'RaiseError' => 1});

while( my $line = <$handle>)  {
    # fejléc
    if($.%2) {
        my $fejlec = $line;
        chop $fejlec;
        my @fields = split ':', $fejlec;
        $m = "'" . join("','", @fields) . "'";
        $reg = $fields[9];
        my @a=($reg=~/\(([0-9]+),([0-9]+)\)/g);
        my @b=($reg=~/(\w{2})-/g);
        my @c=($reg=~/\w{2}-([0-9]+)\(/g);
        $motivum = join(" ",@b);
        $repeat = join(" ",@c);
        $ssr_szam = @a/2;
        $eleje = $a[0];
        $vege = pop @a;
        #if (@a>2) {
            #print "multi primer";
        #}
    } else {
        my $e = substr($line,$eleje-41,40);
        my $v = substr($line,$vege,40);
        my @a=($reg=~/\(([0-9]+,[0-9]+)\)/g);
        my $regio = join(" ",@a);
        # execute INSERT query
        #my $rows = $dbh->do("INSERT INTO fasta (\"H1\",\"H2\",\"H3\",\"H4\",\"H5\",\"H6\",\"H7\",\"H8\",\"H9\",\"H10\",\"regio\",\"eleje\",\"vege\",\"ssr_szam\",\"repeat\",\"motivum\") VALUES ($m,'$regio','$e','$v','$ssr_szam','$repeat','$motivum')");
        # Print something into an output file
        print { $OUTFILE } "INSERT INTO fasta (\"H1\",\"H2\",\"H3\",\"H4\",\"H5\",\"H6\",\"H7\",\"H8\",\"H9\",\"H10\",\"regio\",\"eleje\",\"vege\",\"ssr_szam\",\"repeat\",\"motivum\") VALUES ($m,'$regio','$e','$v','$ssr_szam','$repeat','$motivum');\n" or die "Cannot write to $sql: $!";
    }
    # head-nX emulation for testing
    #last if $. == 200;
}
close $handle;
$dbh->disconnect();
#close $OUTFILE or warn "Cannot close $sql: $!";
