import Cocoa

//parse file
let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day13/input.txt"

func parseFile() -> (maxRow: Int, maxCol: Int, pointArr: [(Int, Int)], foldArr: [String]) {
    
    let url = URL(fileURLWithPath: filePath)
    
    let contents = try! String(contentsOf: url, encoding: .utf8)
    
    let linesArr = contents.components(separatedBy: "\n")
    
    var maxRow = 0
    var maxCol = 0
    //find frist empty line which seperates points from fold instructions
    let index = linesArr.firstIndex(where: {$0 == ""}) ?? 0
    
    let pointArr = linesArr[0..<index].map({ point -> (Int, Int) in
        let split = point.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: true)
        let row = Int(String(split[1]))!
        let col = Int(String(split[0]))!
        if row > maxRow {maxRow = row}
        if col > maxCol {maxCol = col}
        
        return (row, col)
    })
    
    var foldArr = linesArr[index...].map({String($0)})
    foldArr.removeFirst() //trim leftover empty strings
    foldArr.removeLast()
    
    return (maxRow: maxRow, maxCol: maxCol, pointArr: pointArr, foldArr: foldArr)
}

func AddAllPoints(to grid: inout [[Bool]], points: [(row: Int, col: Int)]) {
    points.forEach({
        grid[$0.row][$0.col] = true
    })
}

//for axis X we fold left, for axis Y we fold up
//return smaller grid after discarding values >= value for corresponding axis
func FoldGrid(for grid: [[Bool]], axis: String, value: Int) -> [[Bool]] {
    let rows = grid.count
    let cols = grid[0].count
    
    var newGrid = grid
    
    switch axis {
    case "y", "Y":
        for y_val in (value + 1)..<rows {
            for x_val in 0..<cols {
                if (grid[y_val][x_val] == true) {
                    let mirrored_y = value - (y_val - value)
                    newGrid[mirrored_y][x_val] = true
                }
            }
        }
        //cut what we mirrored
        newGrid.removeSubrange(value...)
    case "x", "X":
        for x_val in (value + 1)..<cols {
            for y_val in 0..<rows {
                if (grid[y_val][x_val] == true) {
                    let mirrored_x = value - (x_val - value)
                    newGrid[y_val][mirrored_x] = true
                }
            }
        }
        //cut what we removed
        for row in 0..<rows {
            newGrid[row].removeSubrange(value...)
        }
    default:
        print("Invalid axis")
    }
    
    return newGrid
}

func ExecuteAllFolds(grid: [[Bool]], folds: [String]) -> [[Bool]] {
    var result = grid
    
    let commands = folds.map({
        $0.components(separatedBy: " ")
    })
    
    commands.forEach({
        let cmd_arr = $0.last!.components(separatedBy: "=")
        result = FoldGrid(for: result, axis: cmd_arr[0], value: Int(cmd_arr[1])!)
    })
    
    return result
}

func PrintGridVisually(grid: [[Bool]]) {
    grid.forEach({
        $0.forEach({
            $0 == true ? print("#", terminator: "") : print(".", terminator: "")
        })
        print("")
    })
}

let data = parseFile()

var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: data.maxCol + 1), count: data.maxRow + 1) //from zero we count

AddAllPoints(to: &grid, points: data.pointArr)

grid = ExecuteAllFolds(grid: grid, folds: data.foldArr)

let dots = grid.reduce(0, {
    $0 + $1.reduce(0, {$0 + ($1 ? 1 : 0)})
})


PrintGridVisually(grid: grid)

