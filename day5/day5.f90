program day5
    implicit none

    integer :: ios, i, j, sum = 0
    character(80) :: line
    integer, dimension(0:1000,0:1000) :: inArray
    do i=0,1000
        do j=0,1000
            inArray(i,j)=0
        end do
    end do

    open(18, file="in5.txt", iostat=ios, status="old") 
    do
       read(18, "(A)" , iostat=ios) line
       if (ios /= 0) exit
       call save_line(line, inArray)
       print *, line
    end do
    !print *, inArray
    do i=0,1000
        do j=0,1000
            if (inArray(i,j) > 1) then
                sum = sum + 1
            end if
        end do
    end do
    print *, "Part 2:", sum
end program

SUBROUTINE save_line(instring, array)
    CHARACTER(50) :: instring
    CHARACTER(30) :: string1, string2
    integer, dimension(0:1000,0:1000) :: array
    INTEGER :: index, index1, index2
    INTEGER :: x1, y1, x2, y2, stat

    instring = TRIM(instring)

    index = SCAN(instring," -> ")
    string1 = instring(1:index-1)
    string2 = instring(index+4:)
    index1 = SCAN(string1,",")
    index2 = SCAN(string2,",")
    read(string1(1:index1-1),*,iostat=stat) x1
    read(string1(index1+1:),*,iostat=stat) y1
    read(string2(1:index2-1),*,iostat=stat) x2
    read(string2(index2+1:),*,iostat=stat) y2
    if (x1 > x2) then
        x1 = x1 + x2
        x2 = x1 - x2
        x1 = x1 - x2
        y1 = y1 + y2
        y2 = y1 - y2
        y1 = y1 - y2
    end if
    if (x1==x2) then
        if (y1 > y2) then
            y1 = y1 + y2
            y2 = y1 - y2
            y1 = y1 - y2
        end if
        do index = y1, y2
            array(x1,index) = array(x1,index) + 1
        end do
    else if (y1==y2) then
        do index=x1, x2
            array(index,y1) = array(index, y1) + 1
        end do
    else
        do index=0, x2-x1
            if (y1 > y2) then
                array(x1+index, y1-index) = array(x1+index, y1-index) + 1
            else
                array(x1+index,y1+index) = array(x1+index, y1+index) + 1
            end if
        end do
    end if

  END SUBROUTINE save_line