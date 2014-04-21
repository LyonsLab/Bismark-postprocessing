#!/usr/bin/perl -w

use strict;

#./perl/get_CG_positions.pl < sequences/HapI.faa > sequences/HapI_CG_pos.txt

$/="\n>";
my $pattern = "CG";
while (<>)
  {
    my ($name, $seq) = split/\n/,$_,2;
    $name =~ s/>//g;
    $seq =~ s/>//g;
    $seq =~ s/\n//g;
    $seq =~ s/\s//g;
    print "#".$name, "\t", "length: ".length ($seq),"\t CpG positions","\n";
    print "#SEQ\tPOSITION\tPATTERN:$pattern\n";
    $seq = uc($seq);
    while ($seq =~ /$pattern/g)
      {
	my $pos = length($`);
	$pos++;
	print join ("\t", $name, $pos, substr ($seq, $pos-1, 2), "+" ),"\n";
      }
    my $rc = reverse($seq);
    $rc =~ tr/ATCG/TAGC/;
    my $len = length($seq);
    while ($rc =~ /$pattern/g)
      {
	my $pos = length($`);
	$pos++;
	print join ("\t", $name, ($len-$pos+1), substr ($rc, $pos-1, 2), "-" ),"\n";
      }
    
  }

