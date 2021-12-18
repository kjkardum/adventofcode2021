
import CoreData
import Foundation

let inputFile = "input.txt"
let tryFileContents: NSString? = try? NSString(contentsOfFile: inputFile, encoding: String.Encoding.ascii.rawValue)
let fileContent = (tryFileContents as! String) ?? "error"
let Splitted = fileContent.split(separator: "=").map(String.init)
let x = Int(Splitted[1].split(separator: ".").map(String.init)[0]) ?? 0
let x2t = Splitted[1].split(separator: ".").map(String.init)[1]
let x2 = Int(x2t.split(separator: ",").map(String.init)[0]) ?? 0
let y = Int(Splitted[2].split(separator: ".").map(String.init)[0]) ?? 0
let y2t = Splitted[2].split(separator: ".").map(String.init)[1]
let y2 = Int(y2t.split(separator: ",").map(String.init)[0]) ?? 0
print(x,x2,y,y2)
let x_limit = max(abs(x), abs(x2))
let y_limit = max(abs(y), abs(y2))
func part1and2() -> (Int, Int) {
    var bestHeight = 0
    var total = 0
    for vx_start in -x_limit...(x_limit+1) {
        for vy_start in -y_limit...(y_limit+1) {
            var vx = vx_start
            var vy = vy_start
            var height = 0
            var pos_X = 0
            var pos_Y = 0
            while (pos_X <= x2 && pos_Y >= y)
            {
                pos_X += vx
                pos_Y += vy
                if (vx > 0) {
                    vx -= 1
                } else if (vx < 0) {
                    vx += 1
                }
                vy -= 1
                height = max(height, pos_Y)
                if ((x <= pos_X && pos_X <= x2) && (y <= pos_Y && pos_Y <= y2))
                {
                    bestHeight = max(bestHeight, height)
                    total += 1
                    break
                }
            }
        }
    }
    return (bestHeight, total)
}
print(part1and2())