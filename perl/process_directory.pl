#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $dir = shift;

process_dir ($dir);

sub process_dir
  {
    my $dir = shift;
    opendir (DIR, $dir);
    my @files;
    while (my $item = readdir(DIR))
      {
	next if $item =~ /^\.?\.$/;
	push @files, "$dir/$item" if -r "$dir/$item";
      }
    closedir DIR;
    foreach my $file (@files)
      {
	if ($file =~ /(\w+)_context/)
	  {
	    print "processing $file\n";
	    my $type = $1;
	    my ($sample) = $file =~ /pair\.(\w+?)_/;
#	    print $type, "\t", $sample,"\n";
	    my $data = process_file($file);
	    print_results($data, $type, $sample);
	  }
	elsif(-d $file)
	  {
	    process_dir($file);
	  }
      }
  }


sub print_results
  {
    my ($data, $type, $sample) = @_;

    open (OUT, ">>".$type."_".$sample.".txt");
    print OUT join ("\t", qw(#SEQ POS METH_COUNT UNMETH_COUNT TOTAL PERCENT_METH PERCENT_UNMETH)),"\n";
    foreach my $seq (sort keys %$data)
      {
	foreach my $pos (sort {$a <=> $b} keys %{$data->{$seq}})
	  {
	    my $meth = $data->{$seq}{$pos}{"+"} ? $data->{$seq}{$pos}{"+"} : 0;
	    my $unmeth = $data->{$seq}{$pos}{"-"} ? $data->{$seq}{$pos}{"-"} : 0;
	    my $total = $meth+$unmeth;
	    print OUT join ("\t", $seq, $pos, $meth, $unmeth, $total, sprintf("%.3f", $meth/$total), sprintf("%.3f",$unmeth/$total) ),"\n";
	  }
      }
    close OUT;
  }

sub process_file
  {
    my $file = shift;
    my %data;
    open (IN, $file);
    while (<IN>)
      {
	chomp;
	next if /^Bismark/;
	my @line = split /\t/;
	my $meth_state = $line[1];
	$data{$line[2]}{$line[3]}{$meth_state}++
      }
    close IN;
    return \%data;
  }
