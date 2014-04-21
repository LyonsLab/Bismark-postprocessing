#!/usr/bin/perl -w

use strict;

my $dir = shift;
opendir (DIR, $dir);
while (my $item = readdir(DIR))
  {
    #next unless $item =~ /clean/;
    process_file("$dir/$item") if -r "$dir/$item";
  }

sub process_file
  {
    my $file = shift;
    my $out_file = $file.".coge_exp.csv";
    open (IN, $file);
    open (OUT, ">$out_file");
    print OUT "#CHR,START,STOP,STRAND,PERCENT_METH,READ_COUNT\n";
    while (<IN>)
      {
	next if /^#/;
	chomp;
	my @line = split/\t/;
	print OUT join (",", $line[0], $line[1], $line[1], 1, $line[5], $line[4]),"\n";
      }
    close IN;
    close OUT;
  }
