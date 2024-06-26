#! /usr/bin/perl

while(<STDIN>) {
    if (m!(.*?)\s*(\d+)\s*->\s*(\d+)!) {
            printf "\t\\item %s %i %s %i\n", $1, $2, ($2+0 > $3+0 ? "\\costdown{}" : "\\costup{}"), $3;
    } 
}