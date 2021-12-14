Imports System

Module Program
    Sub Main(args As String())
        Const file As String = "input.txt"
        Dim temp As New ArrayList
        Dim changesFrom As New ArrayList
        Dim changesTo As New ArrayList
        DIM polymer As String
        FileOpen(1, file, OpenMode.Input)
        polymer = LineInput(1)
        LineInput(1)
        Do While Not EOF(1)
            temp = New ArrayList(LineInput(1).Split(" -> "))
            changesFrom.Add(temp(0))
            changesTo.Add(temp(1))
        Loop
        FileClose(1)
        Console.WriteLine(polymer)
        Console.WriteLine(Part(40, polymer, changesFrom, changesTo).ToString() + " +-1")
    End Sub
    Function Part(limit As Integer, pol As String, changesFrom As ArrayList, changesTo As ArrayList) As Long
        Dim newPol = ""
        Dim pairs as new Dictionary(Of String, Long)
        For i = 0 To pol.Length - 2
            if pairs.ContainsKey(pol.Substring(i, 2)) Then
                pairs(pol.Substring(i,2)) += 1
            else 
                pairs.Add(pol.Substring(i,2), 1)
            End If
        Next
        For round = 0 To limit-1
            dim newPairs as new Dictionary(Of String, Long)
            For Each item in pairs.Keys
                Dim index = changesFrom.IndexOf(item)
                If index <> -1 Then
                    if newPairs.ContainsKey(item(0)+changesTo(index)) Then
                        newPairs(item(0)+changesTo(index)) += pairs(item)
                    else 
                        newPairs.Add(item(0)+changesTo(index), pairs(item))
                    End If
                    if newPairs.ContainsKey(changesTo(index)+item(1)) Then
                        newPairs(changesTo(index)+item(1)) += pairs(item)
                    else 
                        newPairs.Add(changesTo(index)+item(1), pairs(item))
                    End If
                End If
            Next
            pairs = newPairs
            pol = newPol + pol.Substring(pol.Length-1,1)
            Console.WriteLine("generating, round " + round.ToString())
        Next
        Dim maxValue = 0L
        Dim minValue = 1 / 0L
        Dim Values as New Dictionary(Of String, Long)
        For Each item in pairs.Keys
            if Values.ContainsKey(item(0)) Then
                Values(item(0)) += pairs(item)
            else 
                Values.Add(item(0), pairs(item))
            End If
        Next
        For Each item in Values.Values
            maxValue = Math.Max(maxValue, item)
            minValue = Math.Min(minValue, item)
        Next
        Part = maxValue - minValue
    End Function
End Module
