#!/usr/bin/perl -w
use strict;

##############################################################################
open (INENDE, "<de-en-short.txt") || die "cannot open file de-en-short.txt";
# open (INENDE, "<de-en.txt") || die "cannot open file de-en.txt";
open (INIP, "<germanwords.txt") || die "cannot open file germanwords.txt";
open (OUT, ">>out.txt") || die "cannot open file out.txt";


# syntax of de-en.txt file:
# each line is an entry
# german on the left, english on the right, delimiter is double colon '::'
# entries in each language within an entry on a line, are delimiter by a pipe '|'
# the first entry on the left of the german side correspondes to the first entry on the english side: e.g. 
# A|B::a|b 
# where 'A' is the german term for the english term 'a'
# e.g.
# Abbau {m} (von Bodenschätzen) [geol.] [min.] | Abbau des Flözes in voller Mächtigkeit | Abbau im Ausbiss einer Lagerstätte | Abbau in regelmäßigen Abständen | Abbau mit Bergversatz | Abbau mit Druckwasser | Abbau mit Schappe | Abbau mit Versatz | Abbau unter Tage | stufenweiser Abbau | völliger Abbau | vollständiger Abbau | vom Ausstrich ansetzender Abbau :: exploitation; carrying; extracting; extraction; cutting; winning | full-seam extraction | level free workings | open stope with pillar | mining with filling | hydraulic mining | auger mining | stowing exploitation | underground stoping | benching work(ing) | exhaustion | complete extraction | patching
# In widget matches are only against first word (or phrase) in line and the entries are displayed as part of the definition. It does not search through the middle of a line
# sexuelle Abartigkeit {f} [psych.] :: sexual deviancy; sexual deviance
# Search term should be carefully updated to the following and the above rules incorporated
# ^[ ]*SearchTerm[^{:(]

my $englishGermanDict;
my $inip;
my @matchTrue;
my @matchFalse;
my @flashCard;

while(<INENDE>){ $englishGermanDict .= $_; }
while(<INIP>){ $inip .= $_; }
undef $/;

my @iparray = &cleaniPhoneInput($inip);
# print "the array of iphone lookup words is\n";
# print @iparray;
# print "\n\n";
# we now have an array of vocab words from my iPhone

&dictLookUp(\@iparray,$englishGermanDict,\@matchTrue,\@matchFalse);

@flashCard = &splitDefinitionStrings(@matchTrue);

&printToExportFile(\@flashCard,\@matchFalse);


close(INENDE);
close(INIP);
close(OUT);


sub printToExportFile(){
    my ($flashCard,$matchFalse) = @_;

    my $len1 = @$flashCard;  # Length of lookFor array
    for (my $i = 0 ; $i  < $len1 ;  $i++) {
        print OUT $flashCard[$i]->[0];
        print OUT "\t";
        $flashCard[$i]->[1] =~ s!^ *(.+)$!\u$1!mig;
        print OUT $flashCard[$i]->[1];
        print OUT "\n";
    }
# 
    print OUT "THE FOLLOWING WORDs HAD N0 MATCHES";
    my $len2 = @$matchFalse;  # Length of lookFor array
    for (my $i = 0 ; $i  < $len2 ;  $i++) {
        print OUT $matchFalse->[$i];
        print OUT "\n";
    } 
    return;
}

sub cleaniPhoneInput(){
    $_[0] =~ s!([,\t ]+)!!mig;# trim end of each line
    return my @tmp_array = split (/\n/, $_[0]);
}

sub splitDefinitionStrings(){# Each line from the ende file needs to be split into a german word and english component suitable for Quizlet
    my @matchTrue = @_;

#     print "\n array deref:\n";
#     print $matchTrue[0];
#     print "\n";
    my @flashCard;

    my $len3 = @matchTrue;  # Length of lookFor array
    for (my $i = 0 ; $i  < $len3 ;  $i++) {
        if($matchTrue[$i] =~ m/^(.+)::(.+)$/mi){
            $matchTrue[$i] =~ m/^(.+)::(.+)$/mi;

        # create an nested array with the inner arrays anonymous
          push (@flashCard, [$1, $2]);
#         print "DEFREF $flashCard[0]->[1]\n";
        } 
        else {
            print "\nerror: couldn't split defination string\n$matchTrue[$i]\n\n";
        }
    }
    
    return @flashCard;
}

sub dictLookUp(){
    my ($lookFor,$lookIn,$matchTrue,$matchFalse) = @_;
    my @temp;
    
    my $len2 = @$lookFor;  # Length of lookFor array
    for (my $i = 0 ; $i  < $len2 ;  $i++) {
        # print "\narrayref: $lookFor->[$i]";
        if(@temp = $lookIn =~ m/^($lookFor->[$i]\b.+)$/mig) {
        
        # print "\n\nHas match: $lookFor->[$i]\n";
            
            if($lookFor->[$i] eq 'Abnutzung'){
                my $mytemp = @temp;
                # print "\nthe length is $mytemp\n";
            }
            
            
            my $len3 = @temp;  # Length of lookFor array
            for (my $j = 0 ; $j  < $len3 ;  $j++) {
                # print "\n::looping through temp array\n";
#                 print "$temp[$j]\n\n";
                push (@$matchTrue,$temp[$j]);
            }        
        

    }
        else {
            # push to array of words not found
            push(@$matchFalse,$lookFor->[$i]);
            # print " did not find: \n";
            # print "$lookFor->[$i] in else\n";

        }
    }
    
#             print "\nThis is is a list of all matches found:\n";
#             my $len4 = @$matchTrue;  # Length of lookFor array
#             for (my $i = 0 ; $i  < $len4 ;  $i++) {
#                 print "$matchTrue->[$i]\n";
# 
#             }        
# 
#             print "\nThis is is a list of all words with no match:\n";
#             my $len5 = @$matchFalse;  # Length of lookFor array
#             for (my $i = 0 ; $i  < $len5 ;  $i++) {
#                 print "$matchFalse->[$i]\n";
# 
#             }        

    return; # these are modified : ($matchTrue,$matchFalse);

}

__END__
