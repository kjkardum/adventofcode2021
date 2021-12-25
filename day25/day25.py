from itertools import chain


def main() -> None:
    lines = readlines('input.txt')
    copy = None
    counter = 0
    while (copy is None) or not eq2d(lines, copy):
        counter +=1
        copy = [line[:] for line in lines]
        lines = move(lines, (0,1), '>')
        lines = move(lines, (1,0), 'v')
    print("Part 1:", counter)
        
        

def move(lines: list[list[str]], direction: tuple[int], directionchar: str) -> list[list[str]]:
    new_lines =  [line[:] for line in lines]
    for i in range(len(lines)):
        for j in range(len(lines[i])):
            new_x, new_y = (i + direction[0], j + direction[1])
            new_x, new_y = new_x % len(lines), new_y % len(lines[i])
            if 0<=i<len(lines) and 0<=j<len(lines[i]):
                if lines[i][j] == directionchar and lines[new_x][new_y] == '.':
                    new_lines[new_x][new_y] = directionchar
                    new_lines[i][j] = '.'
    return new_lines

def eq2d(first: list[list[str]], second: list[list[str]]) -> bool:
    return list(chain.from_iterable(first)) == list(chain.from_iterable(second))
    

def readlines(filename: str) -> list[list[str]]:
    with open(filename, 'r') as f:
        return list(map(list,(f.read().split("\n"))))


if __name__ == '__main__':
    main()