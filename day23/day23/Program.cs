using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace day23
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(Solve("input.txt"));
            Console.WriteLine(Solve("input2.txt"));
        }

        static int Solve(string filename)
        {
            string workingDirectory = Environment.CurrentDirectory;
            var data = ParseInput(Directory.GetParent(workingDirectory).Parent.Parent.FullName + "/" + filename);
            Console.WriteLine("Start " + filename);
            //Console.WriteLine(SearchQ(data));//, new Dictionary<List<string>, int>()));
            return SearchQ(data);
        }

        class SearchParams : IComparable<SearchParams>
        {
            public List<string> current { get; set; }
            public int depth { get; set; }
            public int cost { get; set; }
            public List<string> previous { get; set; }
            
            public int CompareTo(SearchParams obj)
            {
                return cost - (obj?.cost ?? int.MaxValue);
            }

            public override bool Equals(object? obj)
            {
                if (!(obj is SearchParams)) return false;
                return ((SearchParams) obj).current.SequenceEqual(current);
            }

            public override int GetHashCode()
            {
                return current.Aggregate(19, (current1, item) => current1 * 31 + item.GetHashCode());
            }
        }

        static int SearchQ(List<string> start)
        {
            var q = new PriorityQueue<SearchParams>();
            var states = new Dictionary<SearchParams, int>();
            var startParams = new SearchParams
            {
                current = start,
                depth = 0,
                cost = 0,
                previous = new List<string>() {""}
            };
            states.Add(startParams, 0);
            q.Enqueue(startParams);
            SearchParams currentParams;
            var mini = Int32.MaxValue;
            var miniList = new List<string>();
            var rooms = new[] {2, 4, 6, 8, -1};
            var weight = new[] {1, 10, 100, 1000};
            var correctRooms = new[] {'A', 'B', 'C', 'D','.'};
            while (q.Count() > 0)
            {
                currentParams = q.Dequeue();
                var current = currentParams.current;
                var previous = currentParams.previous;
                var cost = currentParams.cost;
                var depth = currentParams.depth;
                var finished = true;
                for (int i = 0; i < current.Count && finished; i++)
                    if (rooms.Contains(i))
                        for (int j = 0; j < current[i].Length && finished; j++)
                            if (rooms[Array.IndexOf(correctRooms, current[i][j])] != i) finished = false;
                if (finished)
                {
                    if (cost < mini) miniList = new List<string>(previous);
                    mini = Math.Min(cost, mini);
                }

                for (int i = 0; i < current.Count; i++)
                {
                    var source = current[i];
                    var found = -1;
                    var correctRoom = true;
                    for (var s = 0; s < source.Length && correctRoom; s++)
                    {
                        if (source[s] != '.' && found == -1) found = s;
                        if (found != -1 && rooms[Array.IndexOf(correctRooms, source[s])] != i) correctRoom = false;
                    }
                    // if no dot in source or source is room and everything in room is correct
                    if (found == -1 || rooms.Contains(i) && correctRoom) continue;
                    var rev = current[i][found] > 'B';
                    for (
                        var j = rev ? current.Count - 1 : 0;
                        rev ? j >= 0 : j < current.Count;
                        j += rev ? -1 : 1
                    )
                    {
                        if (i == j) continue;
                        //check if path to there exists
                        var mi = Math.Min(i, j);
                        var mj = Math.Max(i, j);
                        var exists = true;
                        for (var p = mi; p <= mj && exists; p++)
                            if (p != i && !rooms.Contains(p) && current[p][0] != '.')
                                exists = false;
                        if (!exists) continue;
                        var destination = current[j];
                        // check if dest room is correct and whether there are no incorrect items in it
                        // or if source is room and dest is hallway
                        var totalMoves = found + (rooms.Contains(i) ? 1 : 0); // add number of dots in room to total moves + 1 for hall above
                        var next = new List<string>(current);
                        if (rooms.Contains(i) && !rooms.Contains(j))
                        {
                            totalMoves += mj - mi;
                            next[i] = new StringBuilder(next[i]) {[found] = '.'}.ToString();
                            next[j] = new StringBuilder(next[j]) {[0] = source[found]}.ToString();
                            totalMoves *= weight[Array.IndexOf(correctRooms, source[found])];
                            var newState = new SearchParams
                            {
                                current = next,
                                depth = depth + 1,
                                cost = cost + totalMoves,
                                previous = previous.Concat(new List<string>() { string.Join(", ", next) + " TOTAL: " + totalMoves}).ToList()
                            };
                            var existingStateCost = states.GetValueOrDefault(newState, int.MaxValue);
                            if (newState.cost >= existingStateCost) continue;
                            states[newState] = newState.cost;
                            q.Enqueue(newState);
                        }
                        else if (rooms[Array.IndexOf(correctRooms, source[found])] == j)
                        {
                            var foundD = 0;
                            for (; foundD < destination.Length; foundD++)
                                if (destination[foundD] != '.')
                                    break;
                            foundD -= 1;
                            //foundD contains index of first dot in destination
                            if (foundD == -1) continue;
                            // check if everything else in destination is at correct place
                            var correctRoomDest = true;
                            for (int d = foundD + 1; d < destination.Length && correctRoomDest; d++)
                                if (destination[d] != source[found])
                                    correctRoomDest = false;
                            if (!correctRoomDest) continue;
                            totalMoves += mj - mi;
                            totalMoves += foundD + 1;
                            next[i] = new StringBuilder(next[i]) {[found] = '.'}.ToString();
                            next[j] = new StringBuilder(next[j]) {[foundD] = source[found]}.ToString();
                            totalMoves *= weight[Array.IndexOf(correctRooms, source[found])];
                            var newState = new SearchParams
                            {
                                current = next,
                                depth = depth + 1,
                                cost = cost + totalMoves,
                                previous = previous.Concat(new List<string>() { string.Join(", ", next) + " TOTAL: " + totalMoves}).ToList()
                            };
                            var existingStateCost = states.GetValueOrDefault(newState, int.MaxValue);
                            if (newState.cost >= existingStateCost) continue;
                            states[newState] = newState.cost;
                            q.Enqueue(newState);
                        }
                    }
                }
            }
            Console.WriteLine(String.Join("\n", miniList));
            return mini;
        }
        
        static List<string> ParseInput(string filename)
        {
            var rawInput = File.ReadAllLines(filename);
            var rooms = new[] {"", "", "", ""};
            foreach (var line in rawInput)
            {
                if (line.Any(c => "ABCD".Contains(c)))
                {
                    var rowAmphipods = line
                        .Where(c => char.IsLetter(c))
                        .Select(c => c.ToString())
                        .ToArray();
                    for (var i = 0; i < 4; i++)
                    {
                        rooms[i] += rowAmphipods[i];
                    }
                }
            }
            return new List<string>() {".", ".", rooms[0], ".", rooms[1], ".", rooms[2], ".", rooms[3], ".", "."};
        }
    }
}