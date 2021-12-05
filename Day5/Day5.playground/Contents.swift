import Cocoa
import Foundation

let filePath = "/Users/guyguy/Documents/Github.nosync/AdventOfCode2021/Day5/input.txt"

typealias point = (x: Int, y: Int)

struct entry {
    /* NOTE: x1 == x2 || y1 == y2 */
    var point1: point /* one end of line */
    var point2: point /* other end of line */
    
    /// update grid based on lines (horiz, vert, diag)
    /// TODO fix code to be modular and use closures/functions
    ///         lots of repetitive code and even copy paste from laziness
    /// - Parameter grid: 1kx1k grid to keep track of visited points
    func AddLineToGrid(for grid: inout [[Int]]) {
        //only consider horizontal/vertical lines
        let minY = min(point1.y, point2.y)
        let minX = min(point1.x, point2.x)
        let maxY = max(point1.y, point2.y)
        let maxX = max(point1.x, point2.x)
        
        switch (point1, point2) {
            case _ where point1.x == point2.x:
                //vert line
                for y in minY...maxY {
                    grid[point1.x][y] += 1
                }
            case _ where point1.y == point2.y:
                for x in minX...maxX {
                    grid[x][point1.y] += 1
                }
            default:
                //diagonal 45 degrees (assume)
                if point1.x == minX {
                    //down diag
                    if point1.y == maxY {
                        var y = maxY
                        for x in minX...maxX {
                            grid[x][y] += 1
                            y -= 1
                        }
                    }
                    else {
                    //up diag
                        var y = minY
                        for x in minX...maxX {
                            grid[x][y] += 1
                            y += 1
                        }
                    }
                }
                else {
                    //down diag
                    if point2.y == maxY {
                        var y = maxY
                        for x in minX...maxX {
                            grid[x][y] += 1
                            y -= 1
                        }
                    }
                    else {
                    //up diag
                        var y = minY
                        for x in minX...maxX {
                            grid[x][y] += 1
                            y += 1
                        }
                    }
                }
        }

    }
    /// init entry struct with array of points as strings
    /// - Parameter pointArr: arr of size 4 where each value if coord val as string [x1, y1, x2, y2]
    init(dataArr: [String]) {
        self.point1 = (Int(dataArr[0]) ?? 0, Int(dataArr[1]) ?? 0)
        self.point2 = (Int(dataArr[2]) ?? 0, Int(dataArr[3]) ?? 0)
        
    }
}

func ParseFileToArr(filePath: String) -> [entry] {
    
    let fileURL = URL(fileURLWithPath: filePath)
    
    guard let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return []
    }
    
    var entryArr = [entry]()
    //parse each line into entry
    var fileLineArr = fileContents.components(separatedBy: "\n")
    fileLineArr.removeLast()
    for line in fileLineArr {
        
        var dataArr = line.components(separatedBy: CharacterSet(charactersIn: ",-> "))
        dataArr.removeAll(where: {$0 == ""})
        
        entryArr.append(entry(dataArr: dataArr))
    }
    
    return entryArr
}
//get # squares in arr with val > 1
func CalcDupPoints(for grid: [[Int]]) -> Int {
    var dupes = 0
    
    grid.forEach({ line in
        line.forEach({ elem in
            if elem > 1 {
                dupes += 1
            }
        })
    })
    
    return dupes
}

func GetOverlap(for entries: [entry]) -> Int {
    //create empty 'grid'
    var grid = [[Int]](repeating: [Int](repeating: 0, count: 1000), count: 1000)
    
    // go over all entries
    for entry in entries {
        entry.AddLineToGrid(for: &grid)
    }
    
    return CalcDupPoints(for: grid)
}

let entries = ParseFileToArr(filePath: filePath)

let overLapPoints: Int = GetOverlap(for: entries)
