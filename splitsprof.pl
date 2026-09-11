#!/usr/bin/env perl
if(!defined($ARGV[1])) {
  print STDERR "usage is $0 -step=<stepname> [<sprof.out.file>]\n";
  print STDERR "extracts the part between 'Step n' and (n rows) of the supplied step in sprof output\n";
  exit(4);
}

#process any -foo[=bar] switches:
eval '$'.$1.'='.(defined($3)?'$3;':'1;') 
while $ARGV[0] =~ /^-([A-Za-z0-9]+)(=(.*))?$/ && shift;

if (not defined($step)) {
  print STDERR "Step not set\n";
  exit(4);
}

$found=0;
while (<>) {
  if( !$found && /Step $step:/i) {
    $found=1;
    $foundAt=$.;
  }
  exit(0) if $found && /\(\d+ rows\)/ && $. > $foundAt;
  if($found && $. > $foundAt && !/^[+-]+$/) {
#   s/^\s+//;
#   s/\s+\|\s+/\|/g;
#   s/\s+\n/\n/;
    print;
  }
  exit(0) if $found && /Step \d/ && $. > $foundAt;
}
