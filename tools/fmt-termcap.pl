#!/usr/bin/env perl
use strict;
use warnings;

@ARGV || push @ARGV, "/etc/termcap";
my $termcap;

{
    local $/;
    $termcap = <>;
}

$termcap =~ s/\\\n//g;                  # continue lines ended with \
$termcap =~ s/^#.*$//mg;                # remove comments
$termcap =~ s/^\s*\n//mg;               # remove blank lines
$termcap =~ s/:\s*:/:/mg;               # remove empty fields
$termcap =~ s/:$//mg;                   # remove trailing :
print $termcap;

