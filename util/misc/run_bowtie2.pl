#!/usr/bin/env perl

use strict;
use warnings;
use Findbin;
use lib ("$FindBin::Bin/../../PerlLib");
use Process_cmd;

my $usage = "usage: $0  target.seq reads_1.fq [reads_2.fq]\n\n";

my $target_seq = $ARGV[0] or die $usage;
my $reads_1_fq = $ARGV[1] or die $usage;
my $reads_2_fq = $ARGV[2];

main: {

    unless (-s "$target_seq.1.bt2") {
        my $cmd = "bowtie2-build $target_seq $target_seq";
        &process_cmd($cmd);
    }

    my $format = ($reads_1_fq =~ /\.fq/) ? "-q" : "-f";
    
    my $bowtie2_cmd = "bowtie2 --local --no-unal -x $target_seq $format ";
    if ($reads_2_fq) {
        $bowtie2_cmd .= " -1 $reads_1_fq -2 $reads_2_fq ";
    }
    else {
        $bowtie2_cmd .= " -U $reads_1_fq ";
    }

    
    &process_cmd($bowtie2_cmd);
    
    exit(0);
}
    