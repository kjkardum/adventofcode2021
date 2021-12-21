import java.io.File
import java.util.concurrent.ConcurrentHashMap
import java.util.stream.Collectors

fun readFileAsLinesUsingReadLines(fileName: String): List<Long>
        = File(fileName).readLines().map {str -> str.split(" ").last().toLong()}

fun main(args: Array<String>) {
    var lines = readFileAsLinesUsingReadLines("input.txt")
    println("Program input: ${lines.joinToString()}")
    println("Part1: ${part1(lines[0]-1, lines[1]-1)}")
    println("Part2: ${part2(lines[0]-1, lines[1]-1)}")
}

fun part1(p1: Long, p2: Long): Long {
    var player1 = 0L
    var player1pos = p1
    var player2 = 0L
    var player2pos = p2
    var dice = -1L
    var round = 0L
    var player1Round = true;
    while (player1 < 1000 && player2 < 1000) {
        round += 1L
        dice += 3L
        if (player1Round) {
            player1pos = (player1pos + dice*3) % 10
            player1 += player1pos + 1L
        } else {
            player2pos = (player2pos + dice*3) % 10
            player2 += player2pos + 1L
        }
        player1Round = !player1Round;
    }
    return (if (player1<player2) player1 else player2) * (dice+1)
}


class Memoizer<T, U> private constructor() {
    private val cache = ConcurrentHashMap<T, U>()
    private fun doMemoize(function: (T) -> U):  (T) -> U =
        { input ->
            cache.computeIfAbsent(input) {
                function(it)
            }
        }
    companion object {
        fun <T, U> memoize(function: (T) -> U): (T) -> U =
        Memoizer<T, U>().doMemoize(function)
    }
}
val countMemoize = Memoizer.memoize { a: Long ->
    Memoizer.memoize { b: Long ->
        Memoizer.memoize { c: Long ->
            Memoizer.memoize { d: Long ->
                count(a, b, c, d)
            }
        }
    }
}


fun count(p1: Long, p2: Long, p1pos: Long, p2pos: Long): Pair<Long, Long> {
    if (p1 >= 21) return Pair(1, 0)
    if (p2 >= 21) return Pair(0, 1)
    var s1=0L
    var s2=0L
    for (dice1 in 1..3) {
        for (dice2 in 1..3) {
            for (dice3 in 1..3) {
                var newp1pos = (p1pos + dice1 + dice2 + dice3) % 10
                var newp1 = p1 + newp1pos + 1
                var res = countMemoize(p2)(newp1)(p2pos)(newp1pos)
                s1 += res.second
                s2 += res.first
            }
        }
    }
    return Pair(s1,s2)
}

fun part2(p1: Long, p2: Long): Long {
    val (s1,s2) = countMemoize(0L)(0L)(p1)(p2)
    return if (s1>s2) s1 else s2
}