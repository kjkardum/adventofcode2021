       identification division.
       program-id. AOC-2021-DAY-1.
       author. Karlo Josip Kardum.
       date-written. 2021-12-01.
       
       environment division.
       input-output section.
       file-control.
           select input-file assign to "day1.input"
           organization is line sequential.

       data division.
       file section.
           fd input-file.
           01 inputline           pic is 9(4).
       
       working-storage section.
           01 reading-file        pic is 9(1) value 1.
           01 number-of-lines     pic is 9(4) value 2000.
           01 input-lines         pic is 9(4) occurs 0 to 2000
                                  depending on number-of-lines.
           01 num-1               pic is 9(4) value 0.
           01 num-2               pic is 9(4) value 0.
           01 num-3               pic is 9(4) value 0.
           01 part-1-sum          pic is 9(4) value 0.
           01 line-sums           pic is 9(4) occurs 0 to 2000
                                  depending on number-of-lines.
           01 part-2-sum          pic is 9(4) value 0.
       
       local-storage section.
           01 i usage unsigned-int value 0.
           01 j usage unsigned-int value 0.
           01 k usage unsigned-int value 0.
       
       procedure division.
       
       01-main.
           open input input-file.
           perform 02-read-file until reading-file = 0.
           close input-file.
           display "Finished reading input...".
           perform 03-find-part-1.
           perform 04-find-part-2.
           stop run.
 
       02-read-file.
           read input-file
                   at end move 0 to reading-file
                   not at end compute input-lines(i) = inputline, 
                   add 1 to i
           end-read.
       
       03-find-part-1.
           perform varying i from 0 by 1 until i = number-of-lines - 1
                   add i 1 giving j
                   set num-1 to input-lines(i)
                   set num-2 to input-lines(j)
                   if num-2 > num-1 then
                             add 1 to part-1-sum
                   end-if
           end-perform.
           display "Part-1 result is " part-1-sum.
       
       04-find-part-2.
           perform varying i from 0 by 1 until i = number-of-lines - 2
                   add i 1 giving j
                   add j 1 giving k
                   set num-1 to input-lines(i)
                   set num-2 to input-lines(j)
                   set num-3 to input-lines(k)
                   subtract 1 from i giving j
                   add num-1 num-2 num-3 giving line-sums(i)
                   if i > 0 and line-sums(i) > line-sums(j) then
                             add 1 to part-2-sum
                   end-if,
           end-perform.
           display "Part-2 result is " part-2-sum.
           