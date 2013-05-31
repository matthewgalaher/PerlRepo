#!/usr/bin/perl -w
use strict;

##############################################################################
open (INENDE, "</Users/galaher/Documents/Dev/dictionary project/perl/de-en-short.txt") || die "cannot open file de-en-short.txt";
# open (INENDE, "</Users/galaher/Documents/Dev/dictionary project/perl/de-en.txt") || die "cannot open file de-en.txt";
open (INIP, "</Users/galaher/Documents/Dev/dictionary project/perl/germanwords.txt") || die "cannot open file germanwords.txt";
open (OUT, ">>/Users/galaher/Documents/Dev/dictionary project/perl/out.txt") || die "cannot open file out.txt";

my $ende;
my $inip;

while(<INENDE>){ $ende .= $_; }
while(<INIP>){ $inip .= $_; }
undef $/;


my @iparray = split (/\n/, $inip);
my @inende = split (/^/, $ende);
my %inende;

for (my $i = 0; $i <= $#inende; $i++) {
    if ($inende[$i] =~ m!::!m){
        $inende[$i] =~ m!^(.+)::(.+)!mi;
        $inende{$1} = $2;
    }
}

# THIS MAY NEED ESCAPE CHARACTERS FOR THE STRINGS TO FIX SOME BUGS

my %outqzlt;
my @match;
foreach my $inende_slotname (keys (%inende)) {
# 	print "hash slotname is: $inende_slotname\n";
# 	print "hash slotvalue is: $inende{$inende_slotname}\n";

    # take the first slotname and check against the array of iphone words
    for (my $x = 0; $x <= $#iparray; $x++) {
        $iparray[$x] =~ s!([,\t ]+)!!mi;#; clean up data. remove commas and white space
        $iparray[$x] =~ s!^(.)!\u$1!mi;#; force initial cap
            # It seems that searching for a version of the word that starts at the begining of each line in de-en.txt file works best.
            if ($inende_slotname =~ m!^\Q$iparray[$x]\E\W!mi){            
           
            push(@match,$x);
           
#             print "hash slotname is: $inende_slotname\n";
#             print "hash slotvalue is: $inende{$inende_slotname}\n";
#             print "iphone array value is: $iparray[$x]\n";

            
            
                # if 'iphone word' found in 'inende' string, push iphone word as slot name with $inende{$inende_slotname} as value of new slot
                # newslotname: $iparray[$x], new value: $inende{$inende_slotname}
                
                $outqzlt{$iparray[$x]} = $inende{$inende_slotname};
                
                # SINCE WE HAVE A MATCH WE DON'T NEED TO CHECK THAT ELEMENT AGAIN
                # WE NOW NEED TO FIGURE OUT HOW TO POP THIS IPHONE WORD OFF THE ARRAY WITHOUT OUT SCREWING UP THE INCREMENT
                # PERHAPS CHANGE FOREACH TO WHILE LOOP
            }
    }

# if the full length of the iphone word list is reach break out of the foreach 'break'
}

for (my $x = 0; $x <= $#match; $x++) {
#     print "There are words that matched: $iparray[$match[$x]]\n";
    print "$match[$x]\n";

}

foreach my $slotname (keys (%outqzlt)) {
# 	print "hash slotname is: $slotname\n";
# 	print "hash slotvalue is: $outqzlt{$slotname}\n";

	print OUT "$slotname\t";
	print OUT "$outqzlt{$slotname}\n";

}


#print OUT $iparray[91];
#print OUT $inip;

close(INENDE);
close(INIP);
close(OUT);


##############################################################################


__END__
