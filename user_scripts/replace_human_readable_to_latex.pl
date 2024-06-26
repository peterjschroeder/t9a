#! /usr/bin/perl

while (my $file = glob("language_specific/EN/*.tex ../Language_specific/EN/*.tex")) {
    open(INFO, $file);
    while(<INFO>) {
    if (m!^\\newcommand\{(\\[^\}]*)\}\{([^\}\\]{3,})\}!) {
        print "$2 -> $1\n";
        $regexp{$2} = $1;
    } 
    }
}

open (DEST, $ARGV[0]);
while(my $line = <DEST>) {
    for (reverse sort{split(/ /, $a)+0 <=> split(/ /, $b)+0} keys %regexp) {
        $line =~ s/([^\\])\b$_\b/"$1$regexp{$_}\{\}"/gei;
#        $rex = "\\" . $regexp{$_};
#        $line =~ s/($rex) /$1\{\} /g;
    }
    $file .= "$line";
}

open(DEST, ">", $ARGV[0]);

print DEST $file;