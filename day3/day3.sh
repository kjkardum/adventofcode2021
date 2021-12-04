#!/bin/bash

((length = 12)) # 5 or 12

declare -a positions
o2=0
co2=0

function part1 {
    for pos in {0..11}; do # 4 or 11
        for line in "${lines[@]}"; do
            bin_line=$((2#$line))
            ((positions[$pos] += ($bin_line & $[2**$pos]) == $[2**$pos]))
        done
    done
    for pos in {0..11}; do
        ((positions[$pos] = positions[$pos] * 2 >= ${#lines[*]}))
    done
    declare -a rev
    for (( i=${#positions[*]}-1; i>=0; i-- ))
        do rev[${#rev[@]}]=${positions[i]}
    done
    IFS=
    number="${rev[*]/#/$sep}"
    bin_number=$((2#$number))
    ((result=$bin_number*($[2**$length]-$bin_number-1)))
    echo $result
}

function part2o {
    line_count=${#lines[*]}
    for pos in {11..-1}; do
        for line in "${lines[@]}"; do
            bin_line=$((2#$line))
            ((positions[$pos] += ($bin_line & $[2**$pos]) == $[2**$pos]))
        done
        ((positions[$pos] = positions[$pos] * 2 >= ${#lines[*]}))
        newlines=()
        for line in "${lines[@]}"; do
            if ((line_count==1)); then
                echo "O2" $((2#$line))
                o2=$((2#$line))
                return
            fi
            bin_line=$((2#$line))
            if (((($bin_line & $[2**$pos]) == $[2**$pos]) == positions[$pos])); then
                newlines+=("$line")
            else
                ((line_count-=1))
            fi
        done
        if ((${#newlines[*]}==0)); then
            echo "${lines[${#lines[@]}-1]}"
            return
        fi
        lines=(${newlines[*]})
    done
}

function part2c {
    line_count=${#lines[*]}
    for pos in {11..-1}; do
        for line in "${lines[@]}"; do
            bin_line=$((2#$line))
            ((positions[$pos] += ($bin_line & $[2**$pos]) == $[2**$pos]))
        done
        ((positions[$pos] = positions[$pos] * 2 < ${#lines[*]}))
        newlines=()
        for line in "${lines[@]}"; do
            if ((line_count==1)); then
                echo "C02" $((2#$line))
                co2=$((2#$line))
                return
            fi
            bin_line=$((2#$line))
            if (((($bin_line & $[2**$pos]) == $[2**$pos]) == positions[$pos])); then
                newlines+=("$line")
            else
                ((line_count-=1))
            fi
        done
        if ((${#newlines[*]}==0)); then
            echo "${lines[${#lines[@]}-1]}"
            return
        fi
        lines=(${newlines[*]})
    done
}

read -d '' -a linesb < in3
lines=("${linesb[@]}")
echo "part1 :"
part1
echo "..."
lines=("${linesb[@]}")
part2o
lines=("${linesb[@]}")
part2c

((res=$o2*$co2))
echo "part2 :"
echo $res
