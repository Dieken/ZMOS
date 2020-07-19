#!/usr/bin/env perl
#
# Purpose:
#   Print charset range covered by a font
#
# Usage:
#   ./fc-charset.pl /path/to/some/truetype/or/opentype/font/file

use strict;
use warnings;

my ($from, $to);

open(my $fh, "-|", "fc-query", @ARGV) or die "Can't run fc-query on $ARGV[0]: $!\n";
while (<$fh>) {
    chomp;
    if (/^\t(?:[0-9a-f]{4}):(?: (?:[0-9a-f]{8})){8}$/) {
        my @a = split / /, $_;
        $a[0] =~ s/[\s:]//g;

        my $prefix = shift @a;

        if (defined $from) {
            if (index($to, sprintf("%04X", hex($prefix) - 1)) < 0) {
                print " $to\n";
                undef $from;
            }
        }

        for (my $i = 0; $i < 8; ++$i) {
            my $bits = hex($a[$i]);
            for (my $j = 0; $j < 32; ++$j) {
                if ($bits & (1 << $j)) {
                    $to = uc($prefix . sprintf("%02x", $i * 32 + $j));
                    unless (defined $from) {
                        $from = $to;
                        print $from;
                    }
                } else {
                    if (defined $from) {
                        print " $to\n";
                        undef $from;
                    }
                }
            }
        }
    }
}
print " $to\n" if defined $from;
close $fh;
