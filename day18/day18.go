package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"math"
	"os"
	"regexp"
	"strconv"
)

func readLines(path string) []string {
	file, _ := os.Open(path)
	defer file.Close()
	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}

func explode(line string, left, right int) string {
	var ints []int
	_ = json.Unmarshal([]byte(line[left:right+1]), &ints)
	rightNumRe, _ := regexp.Compile("(\\d+)([,\\]\\[]*$)")
	leftNumRe, _ := regexp.Compile("^([^\\d]*)(\\d+)")
	IndexBefore := rightNumRe.FindStringSubmatchIndex(line[:left])
	IndexAfter := leftNumRe.FindStringSubmatchIndex(line[right:])
	if IndexAfter != nil {
		IndexAfter[4] += right
		IndexAfter[5] += right
		IndexAfter = IndexAfter[4:6]
		afterAsInt, _ := strconv.Atoi(line[IndexAfter[0]:IndexAfter[1]])
		line = line[:IndexAfter[0]] + strconv.Itoa(afterAsInt+ints[1]) + line[IndexAfter[1]:]
	}
	if IndexBefore != nil {
		IndexBefore = IndexBefore[2:4]
		beforeAsInt, _ := strconv.Atoi(line[IndexBefore[0]:IndexBefore[1]])
		newBefore := strconv.Itoa(beforeAsInt + ints[0])
		left += len(newBefore) - len(line[IndexBefore[0]:IndexBefore[1]])
		right += len(newBefore) - len(line[IndexBefore[0]:IndexBefore[1]])
		line = line[:IndexBefore[0]] + newBefore + line[IndexBefore[1]:]
	}
	return line[:left] + "0" + line[right+1:]
}

func splitarr(line string) string {
	allNumsRe, _ := regexp.Compile("(\\d+)")
	Indexes := allNumsRe.FindAllStringIndex(line, -1)
	for i := 0; i < len(Indexes); i += 1 {
		sliceAsInt, _ := strconv.Atoi(line[Indexes[i][0]:Indexes[i][1]])
		if sliceAsInt >= 10 {
			line = line[:Indexes[i][0]] + "[" + strconv.Itoa(int(math.Floor(float64(sliceAsInt)/2.))) + "," + strconv.Itoa(int(math.Ceil(float64(sliceAsInt)/2.))) + "]" + line[Indexes[i][1]:]
			return line
		}
	}
	return line
}

func magnitude(line string) string {
	var stack []int
	var ints []int
	for i := 0; i < len(line); i++ {
		value := line[i]
		if value == '[' {
			stack = append(stack, i)
		} else if value == ']' {
			idx := stack[len(stack)-1]
			stack = stack[:len(stack)-1]
			_ = json.Unmarshal([]byte(line[idx:i+1]), &ints)
			line = line[:idx] + strconv.Itoa(3*ints[0]+2*ints[1]) + line[i+1:]
			i = idx + 1
		}
	}
	return line
}

func reduce(line string) string {
	reduce := true
	for reduce {
		reduce = false
		depth, left, right := 0, -1, -1
		for i, value := range line {
			if value == '[' {
				depth++
			} else if value == ']' {
				depth--
			}
			if depth == 5 && left == -1 {
				left = i
			}
			if depth < 5 && left != -1 {
				right = i
				break
			}
		}
		if left != -1 && right != -1 {
			reduce = true
			line = explode(line, left, right)
		}
		if !reduce {
			oldline := line
			line = splitarr(line)
			if oldline != line {
				reduce = true
			}
		}
	}
	return line
}

func main() {
	lines := readLines("input.txt")
	largest := 0
	for i := 0; i < 100; i++ {
		for j := 0; j < len(lines); j++ {
			if i != j {
				magnitudeAsInt, _ := strconv.Atoi(magnitude(reduce("[" + lines[i] + "," + lines[j] + "]")))
				largest = int(math.Max(float64(largest), float64(magnitudeAsInt)))
			}
		}
	}
	for len(lines) > 1 {
		lines[1] = "[" + lines[0] + "," + lines[1] + "]"
		lines = lines[1:]
		lines[0] = reduce(lines[0])
	}
	fmt.Println("Part 1: ", magnitude(lines[0]))
	fmt.Println("Part 2: ", largest)
}
