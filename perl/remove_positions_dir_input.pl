#!/usr/bin/perl -w

use strict;

my $remove_pos = "/storage/elyons/projects/bisulfite_mouse-human/perl/remove_positions.pl";
my $dir = shift;


#position files for various Hap sequences
my $hapI = "/storage/elyons/projects/bisulfite_mouse-human/data/v4/sequences/Hap1_positions.txt";
my $hapII = "/storage/elyons/projects/bisulfite_mouse-human/data/v4/sequences/Hap2_positions.txt";
my $hapIII = "/storage/elyons/projects/bisulfite_mouse-human/data/v4/sequences/Hap3_positions.txt";
my $new_seq = "/home/elyons/projects/bisulfite_mouse-human/data/v3/sequences/new_HapI_GC_positions.txt";

unless (-r $dir)
  {
    print qq{
Usage:  $0 directory_to_process
};
    exit;
  }


process_dir ($dir);

sub process_dir
  {
    my $dir = shift;
    my @items;
    opendir (DIR, $dir);
    while (my $item = readdir(DIR))
      {
	if ($item =~ /CpG_H(\d)/)
	  {
	    my $num = $1;
	    my $pos_file;
	    $pos_file = $hapI if $num == 1;
	    $pos_file = $hapII if $num == 2;
	    $pos_file = $hapIII if $num == 3;
	    #defaulting to use new_seq for everything;
	    #$pos_file = $new_seq;
	    unless ($pos_file)
	      {
		print "WARNING:  can't determin correct position file for $item.  Skipping. . . \n";
		next;
	      }
	    my $cmd = $remove_pos . " -pf $pos_file -df $dir/$item > $dir/$item.clean";
	    print "Running $cmd\n";
	    `$cmd`;
	  }
      }
      
  }
