program day12;
uses
    sysutils,
    strutils;
type
  matrix = array[0..23, 0..2] of string;
var
    lines: matrix;
    startpath: array[0..1000] of string;
    n, line: integer;
    inputFile: file of char;
    curr: string;
    ch: char;
    function countPaths(path: array of string; pathlen: integer; twice: boolean): longint;
    var
        i, j, found: integer;
        result: longint;
        newNode: string;
    begin
        if path[pathlen] = 'end' then
            exit(1);
        result := 0;
        for i := 0 to n do
            if (CompareStr(lines[i, 0],path[pathlen]) = 0) or (CompareStr(lines[i, 1],path[pathlen]) = 0) then
            begin
                if CompareStr(lines[i, 0],path[pathlen]) = 0 then
                    newNode := lines[i, 1]
                else
                    newNode := lines[i, 0];
                found := 0;
                if lowercase(newNode) = newNode then
                    for j := 0 to pathlen - 1 do
                        if CompareStr(newNode,path[j]) = 0  then
                            found += 1;
                if ((found = 1) and not twice) or (found = 0) then
                begin
                    path[pathlen + 1] := newNode;
                    pathlen := pathlen + 1;
                    result += countPaths(path, pathlen, (found = 1) or twice);
                    pathlen := pathlen - 1;
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
    startpath[0] := 'start';
    writeln(countPaths(startpath, 0, true));
    startpath[1] := 'start';
    writeln(countPaths(startpath, 1, false));
end.