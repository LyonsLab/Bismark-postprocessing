#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Data::Dumper;

my ($data_file, $pos_file);

GetOptions ( 
            "data_file|df=s"                     => \$data_file,
            "position_file|pf=s"                     => \$pos_file,
	   );

unless (-r $data_file && -r $pos_file)
  {
    print qq{
Welcome to $0!

This program removes data from the data file that is not in the position file.

Usage:  $0 -df <data_file> -pf <position_file>

./perl/remove_positions.pl -pf sequences/HapI_CG_pos.txt -df results/v1/CpG_1070.txt 
};
    exit;
  }


my $pos = get_pos($pos_file);
parse_data(file=>$data_file, pos=>$pos);

sub parse_data
  {
    my %opts = @_;
    my $file = $opts{file};
    my $pos = $opts{pos};
    open (IN, $file);
    while (<IN>)
      {
	if (/^#/)
	  {
	    print $_;
	    next;
	  }
	my @line = split/\t/;
	unless ($pos->{$line[0]})
	  {
	    warn "Potential error: sequence ".$line[0]." is not in the position file\n";
	  }
	next unless $pos->{$line[0]}{$line[1]};
	print join ("\t", @line);
      }
    close IN;
  }

sub get_pos
  {
    my $file = shift;
    my %data;
    open (IN, $file);
    my $seq_name;
    while (<IN>)
      {
	chomp;
	next if /^#/;
	my ($name, $pos) = split/\t/;
	$data{$name}{$pos}=1;
      }
    close IN;
    return \%data;
  }

