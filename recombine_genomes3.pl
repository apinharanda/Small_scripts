#!perl 


#2020 script by P Andolfatto

####Ana's notes
#from two reference genomes simulate constant recombination 
##example
## extract X chromosome and make diploid
#zcat DyakST_realigned_MPILEUP_final_pseudoref.div_only.upper.bad_sites_masked.fasta.gz.Z | perl getScaffold_samtools_gz.pl X >Dyak_ST_X.fa
#zcat DyakJess_realigned_MPILEUP_final_pseudoref.upper.bad_sites_masked.fasta.gz.Z | perl getScaffold_samtools_gz.pl X >Dyak_Jess_X.fa

# changed chrom names X->X_Dyak_ST and X->X_Dyak_Jess, its important the two chrs dont have the same name!
# combine 
#cat Dyak_ST_X.fa Dyak_Jess_X.fa >Dyak_ST_Jess_diploidX.fa
# check 
#grep -A 1 \> Dyak_ST_Jess_diploidX.fa
#>X_Dyak_ST
#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNGGCTGCCAGCGTGGTGCT
#--
#>X_Dyak_Jess
#NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNGGCTGCCAGCGTGGTGCT
#
# generate recombinant backcross individuals 
# usage: perl recombine_genomes.pl infile scaffold backcross_to_parent(0,1) #progeny
#perl recombine_genomes3.pl Dyak_ST_Jess_diploidX.fa X 0 10 >breakpoints



##########shared by Peter
# creates a recombiant diploid genome from diploid fasta,
# one recombination event per individual
# assumes F1 backcross to specified parent

# example, Dmel X chrom, backcross to second sequence, one recombinant progeny
# perl recombine_genomes3.pl Dmelref_X X 1 1

if (@ARGV < 4){print "\nusage: perl recombine_genomes.pl infile scaffold backcross_to_parent(0,1) #progeny\n\n";exit;}

use POSIX;
use Math::Random qw(:all);
srand(time());

my $infile = shift(@ARGV); chomp $infile;
open REF, $infile or die "wrong format for infile\n";

my $scaffold =  shift(@ARGV); chomp $scaffold;
my $parent =  shift(@ARGV); chomp $parent;
my $num_progeny =  shift(@ARGV); chomp $num_progeny;

# my $list = shift(@ARGV); chomp $list;
# open IN, "cut -f 1 $list |";

my %data = (); my @sequence_names = ();
my @sequence_temp =(); my @data_temp =();	
#**************** read in sequence & create output sequence
	while (my $line = <REF>) {
		chomp $line;
		$line =~ s/\s+//g; # remove all white spaces
		$line =~ s/type/\ttype/g; # insert a tab
		if ($line =~ />/) {
			(my $name, my $other) = split(/\t/, $line); chomp $name;
			push(@sequence_names, $name);
			$sequence_temporary = join ("", @data_temp);
			push(@sequence_temp,$sequence_temporary); 
			@data_temp=();
			} 
		else {push(@data_temp, $line);}
		}
	close REF;
	$sequence_temporary = join ("", @data_temp);
	push(@sequence_temp,$sequence_temporary); 
	for $x (0..(scalar(@sequence_names)-1))	{  # put sequences into %data
		$data{$sequence_names[$x]}=$sequence_temp[$x+1];
		}

my $seq_count = scalar (keys (%data));
print "# of sequences loaded: $seq_count\n";

my @sequences=(); my @names=();
foreach $key (sort keys (%data)){ #this part assigns the two sequences for a particular scaffold to an array
	if (substr($key,0) =~ /$scaffold/) {
		print "$key\n";
		push(@names, $key);
		push(@sequences, $data{$key});
		}
}

#determine positions of breaks
my @positions=();
$length = length($sequences[0]); print "seq length: $length\n";
for $i (0..($num_progeny-1)){push(@positions,random_uniform_integer(1, 1, $length));}

# sort the arrays numerically
# my @positions1_sorted = sort { $a <=> $b } @positions1;

# check
# print "chrom1:\n"; for $k (0..(scalar(@positions)-1)){print $positions[$k], "\t";} print "\n";
# print out true breakpoint positions
for $l (0..(scalar(@positions)-1)){print $positions[$l], "\n";} print "\n";


# construct recombinant individual
my $current_ind = int(rand()+0.5); # randomly start with indiv 0 or 1
my $other_indiv = "";
if ($current_ind==0){$other_indiv=1;}
else{$other_indiv=0;}

# check
# print "current: $current_ind \t other: $other_indiv\n";

my $indiv="";
for $m (0..(scalar(@positions)-1)){
    
    $indiv=substr($sequences[$current_ind], 0, $positions[$m]).substr($sequences[$other_indiv], $positions[$m]);

    # check
    # print "length orig: ", length($sequences[0]), "\tlength new: ", length($indiv), "\n";

    # print
    open OUT, ">indiv_".$m."_".$positions[$m].".fa";
    # print "backcross parent: $parent\n"; print "$sequences[$parent]\n";
    print OUT ">indiv_".$m."_a\n$indiv\n>indiv_".$m."_b\n$sequences[$parent]\n";
 
} # for all positions


