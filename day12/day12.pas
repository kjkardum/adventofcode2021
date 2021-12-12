program day12;
uses
    sysutils,
    strutils;
type
  matrix = array[0..23, 0..2] of string;
var
    lines: matrix;
    startpath: array[0..1000] of string;
    n: integer;
    part1, part2: longint;
    inputFile: file of char;
    curr: string;
    ch: char;
    i, j, k, l, m, nn, line: integer;
    function countPaths(path: array of string; pathlen: integer): integer;
    var
        i, j, result: integer;
        newNode: string;
        found: boolean;
    begin
        if path[pathlen] = 'end' then
        begin
            writeln(dupestring(' ', pathlen), path[pathlen], ' ', pathlen);
            exit(1);
        end;
        result := 0;
        for i := 0 to n do
        begin
            if (CompareStr(lines[i, 0],path[pathlen]) = 0) or (CompareStr(lines[i, 1],path[pathlen]) = 0) then
            begin
                if CompareStr(lines[i, 0],path[pathlen]) = 0 then
                    newNode := lines[i, 1]
                else
                    newNode := lines[i, 0];
                writeln(dupestring(' ',pathlen), path[pathlen], ' > ', newNode);
                found := false;
                if lowercase(newNode) = newNode then
                begin
                    for j := 0 to pathlen - 1 do
                    begin
                        if CompareStr(newNode,path[j]) = 0  then
                            found := true;
                    end;
                end;
                if not found then
                begin
                    path[pathlen + 1] := newNode;
                    pathlen := pathlen + 1;
                    result += countPaths(path, pathlen);
                    pathlen := pathlen - 1;
                end;
            end;
        end;
        exit(result);
    end;
    function countPathsPart2(path: array of string; pathlen: integer; twice: boolean): longint;
    var
        i, j: integer;
        result: longint;
        newNode: string;
        found: integer;
    begin
        if path[pathlen] = 'end' then
        begin
            //writeln(dupestring(' ', pathlen), path[pathlen], ' ', pathlen);
            exit(1);
        end;
        result := 0;
        for i := 0 to n do
        begin
            if (CompareStr(lines[i, 0],path[pathlen]) = 0) or (CompareStr(lines[i, 1],path[pathlen]) = 0) then
            begin
                if CompareStr(lines[i, 0],path[pathlen]) = 0 then
                    newNode := lines[i, 1]
                else
                    newNode := lines[i, 0];
                //writeln(dupestring(' ',pathlen), path[pathlen], ' > ', newNode);
                found := 0;
                if lowercase(newNode) = newNode then
                begin
                    for j := 0 to pathlen - 1 do
                    begin
                        if CompareStr(newNode,path[j]) = 0  then
                            found += 1;
                    end;
                end;
                if ((found = 1) and not twice) or (found = 0) then
                begin
                    path[pathlen + 1] := newNode;
                    pathlen := pathlen + 1;
                    result += countPathsPart2(path, pathlen, (found = 1) or twice);
                    pathlen := pathlen - 1;
                end;
            end;
        end;
        exit(result);
    end;
begin
    n := 0;
    curr := '';
    assign(inputFile, 'input.txt');
    reset(inputFile);
    while not eof(inputFile) do
    begin
        read(inputFile, ch);
        if ch = '-' then
        begin
            lines[n, 0] := curr;
            curr := '';
        end
        else if ch = #10 then
        begin
            lines[n, 1] := curr;
            curr := '';
            n += 1;
        end
        else
            curr := curr + ch;
    end;
    n -= 1;
    writeln('lines:');
    for line := 0 to n do
        writeln(lines[line,0] + ' ' + lines[line,1]);
    startpath[0] := 'start';
    part1 := countPaths(startpath, 0);
    writeln('---');
    startpath[1] := 'start';
    part2 := countPathsPart2(startpath, 1, false);
    writeln('number of paths:');
    writeln(part1);
    writeln(part2);
end.