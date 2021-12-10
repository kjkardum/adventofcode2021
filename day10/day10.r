lines = readLines("input.txt")
H <- new.env() 
H[[")"]] <- 3
H[["]"]] <- 57
H[["}"]] <- 1197
H[[">"]] <- 25137
find_wrong_closing_bracket <- function (str) {
    stack = list()
    for (c in strsplit(str, "")[[1]]) {
        if (c == '(' | c == '[' | c == '{' | c == '<') {
            stack = append(stack, c)
        } else if (c == ')' & tail(stack,1) == '(' | c == ']' & tail(stack,1) == '[' | c == '}' & tail(stack,1) == '{' | c == '>' & tail(stack,1) == '<') {
            stack = stack[-length(stack)]
        } else {
            return(c)
        }
    }
    return(1)
}

add_missing_closing_brackets <- function (str) {
    stack = list()
    for (c in strsplit(str, "")[[1]]) {
        if (c == '(' | c == '[' | c == '{' | c == '<') {
            stack = append(stack, c)
        } else if (c == ')' & tail(stack,1) == '(' | c == ']' & tail(stack,1) == '[' | c == '}' & tail(stack,1) == '{' | c == '>' & tail(stack,1) == '<') {
            stack = stack[-length(stack)]
        }
    }
    total = 0
    for (c in rev(stack)) {
        total = total * 5
        if (c == "(") {
            total = total + 1
        } else if (c == "[") {
            total = total + 2
        } else if (c == "{") {
            total = total + 3
        } else if (c == "<") {
            total = total + 4
        }
    }
    return(total)
}

res = 0
res2 = list()
part2lines = list()
for (line in lines) {
    wrong_bracket = find_wrong_closing_bracket(line)
    if (wrong_bracket != 1) {
        if (wrong_bracket == ")") {
            res = res + 3
        } else if (wrong_bracket == "]") {
            res = res + 57
        } else if (wrong_bracket == "}") {
            res = res + 1197
        } else if (wrong_bracket == ">") {
            res = res + 25137
        }
    } else {
        part2lines = append(part2lines, line)
    }
}
print(res)
for (line in part2lines) {
    res2 = append(res2, add_missing_closing_brackets(line))
}
res2=res2[order(unlist(res2))]
print(res2[[length(res2)/2 + 1]])