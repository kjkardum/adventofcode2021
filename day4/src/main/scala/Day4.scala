import scala.collection.mutable.ListBuffer
import scala.io.Source
import scala.util.Properties.lineSeparator

object Day4 {
  private def readInput(): IndexedSeq[String] = Source.fromFile("input.txt").getLines().mkString("\n").split(lineSeparator).toIndexedSeq

  def drawCards(): Any = {
    var playing = cards.length;
    var finished = ListBuffer[Int]()
    var part1 = 0;
    for(i <- nums.indices) {
      for(card <- cards.indices) {
        for(row <- cards(card).indices){
          for(column <- cards(card).indices) {
            if (cards(card)(row)(column) == nums(i)) {
              drawnCards(card)._1(row) += 1;
              drawnCards(card)._2(column) += 1;
              if (drawnCards(card)._1(row) == 5 || drawnCards(card)._2(column) == 5) {
                if (playing == cards.length) {
                  part1 = nums(i) * cards(card).map(row=>row
                    .filter(j => !nums.slice(0, i+1).contains(j))
                    .sum).sum;
                }
                if (!finished.contains(card)) {
                  playing -= 1;
                  finished += card;
                }
              }
              if (playing == 0) {
                return (part1, nums(i) * cards(card).map(row=>row
                  .filter(j => !nums.slice(0, i+1).contains(j))
                  .sum).sum)
              }
            }
          }
        }
      }
    }
  }

  val nums: Array[Int] = readInput().head.split(",").map((i) => (i.toInt));

  val cards: Array[Array[Array[Int]]] = ("\n"+readInput().tail.mkString("\n"))
    .split("\n\n").tail
    .map(i => i.split("\n").map(i=>i.trim.split(" +").map(i=>i.toInt)));

  val drawnCards: Array[(Array[Int], Array[Int])] = cards.
    map(card=>(new Array[Int](5), new Array[Int](5)));

  def main(args: Array[String]): Unit = {
    println(drawCards())
  }
}