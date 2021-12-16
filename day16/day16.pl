#!/usr/bin/perl

use strict;

use List::Util qw(sum min max product);
open my $file, '<', "input.txt"; 
my $firstLine = <$file>; 
close $file;
my $num_bin = "";
for(my $i = 0; $i < length($firstLine); $i++) {
    my $num = hex(substr($firstLine, $i, 1));
    $num_bin .= sprintf('%04b', $num);
}
my $packet = readPackage(0,0);
print part1($packet) . "\n";
print part2($packet) . "\n";
sub part1 {
    my ($package) = @_;
    my $totalVersionSum = $package->{version};
    if ($package->{instruction} ne 4) {
        foreach my $pack ( @{ $package->{packets} } ) {
            $totalVersionSum += part1($pack);
        }
    }
    return $totalVersionSum;
}
sub part2 {
    my ($package) = @_;
    if ($package->{instruction} == 4) {
        return $package->{value};
    }
    my @results;
    foreach my $pack ( @{ $package->{packets} } ) {
            push @results, part2($pack);
    }
    if ($package->{instruction} == 0) {
        return sum @results;
    }
    elsif ($package->{instruction} == 1) {
        return product @results;
    }
    elsif ($package->{instruction} == 2) {
        return min @results;
    }
    elsif ($package->{instruction} == 3) {
        return max @results;
    }
    elsif ($package->{instruction} == 5) {
        return $results[0] > $results[1];
    }
    elsif ($package->{instruction} == 6) {
        return $results[0] < $results[1];
    }
    elsif ($package->{instruction} == 7) {
        return $results[0] == $results[1];
    }
    else {
        print "ERROR: unknown instruction: " . $package->{instruction} . "\n";
    }
}
sub printPackage {
    my ($package, $depth) = @_;
    print " " x $depth . "version: " . $package->{version} . "\n";
    print " " x $depth .  "instruction: " . $package->{instruction} . "\n";
    if ($package->{instruction} eq 4) {
        print " " x $depth .  "value: " . $package->{value} . "\n";
    } else {
        print " " x $depth .  "usePacketsCount: " . $package->{usePacketsCount} . "\n";
        print " " x $depth .  "length: " . $package->{length} . "\n";
        print " " x $depth .  "packets: [" . "\n";
        foreach my $pack ( @{ $package->{packets} } ) {
            print " " x $depth . " {" . "\n";
            printPackage($pack, $depth+2);
            print " " x $depth . " }," . "\n";
        }
        print " " x $depth .  "]\n";
    }

}
sub bin2dec {
    return oct("0b".@_[0]);
}
sub readPackage {
    my @args = @_;
    my $startIndex = $args[0];
    my $depth = $args[1];
    my %package = {
        version => 0,
        instruction => 0,
        value => 0,
        usePacketsCount => 0,
        length => 0,
        packets => [],
        binaryLength => 0,
        depth => $depth,
    };
    $package{version} = bin2dec(substr($num_bin, $startIndex, 3));
    $startIndex += 3;
    $package{instruction} = bin2dec(substr($num_bin, $startIndex, 3));
    $startIndex += 3;
    if ($package{instruction} == 4) {
        my $valueStr = "";
        do {
            $valueStr .= substr($num_bin, $startIndex + 1, 4);
            $startIndex += 5;
        } while (substr($num_bin, $startIndex-5, 1) ne "0");
        $package{value} = bin2dec($valueStr);
    } else {
        $package{usePacketsCount} = bin2dec(substr($num_bin, $startIndex, 1));
        $startIndex += 1;
        if ($package{usePacketsCount} == 0) {
            $package{length} = bin2dec(substr($num_bin, $startIndex, 15));
            $startIndex += 15;
            for (my $i = 0; $i < $package{length};) {
                my $subPacket = readPackage($startIndex, $depth + 1);
                push @{$package{packets}}, $subPacket;
                $startIndex += $subPacket->{binaryLength};
                $i += $subPacket->{binaryLength};
            }
        } else {
            $package{length} = bin2dec(substr($num_bin, $startIndex, 11));
            $startIndex += 11;
            for (my $i = 0; $i < $package{length}; $i++) {
                my $subPacket = readPackage($startIndex, $depth + 1);
                push @{$package{packets}}, $subPacket;
                $startIndex += $subPacket->{binaryLength};
            }
        }
    }
    $package{binaryLength} = $startIndex - $args[0];
    return \%package;
}