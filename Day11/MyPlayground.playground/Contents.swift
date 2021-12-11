import Cocoa

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day11/input.txt"

func parseDumboOctopusFile() -> [[Int?]] {
    let url = URL(fileURLWithPath: filePath)
    
    guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
        return []
    }
    
    var linesArr = contents.components(separatedBy: "\n")
    //remove last empty line
    linesArr.removeLast()
    
    //parse each line into int array
    let arr: [[Int?]] = linesArr.map({
        $0.map({$0.wholeNumberValue})
    })
    
    return arr
}

func GetNextFlashPos(for grid: [[Int?]]) -> (row: Int, col: Int)? {
    
    var row: Int = -1
    var col: Int = -1
    
    if let rowIdx = grid.firstIndex(where: {
        if let colIdx = $0.firstIndex(where: {$0 != nil && $0! > 9}) {
            col = colIdx
            return true
        }
        return false
    }) {
        row = rowIdx
    }
    
    return (row != -1 && col != -1) ? (row, col) : nil
}

//iterable enum for 8 adjacent squares
enum Adjacent: CaseIterable {
    case UpLeft, Up, UpRight, Left, Right, BotLeft, Bot, BotRight
    
    var AddToPos : (Int, Int) {
        switch self {
        case .UpLeft: return (-1, -1)
        case .Up: return (-1, 0)
        case .UpRight: return (-1, 1)
        case .Left: return (0, -1)
        case .Right: return (0, 1)
        case .BotLeft: return (1, -1)
        case .Bot: return (1, 0)
        case .BotRight: return (1, 1)
        }
    }

}

func isValid(row: Int, col: Int, grid: [[Int?]]) -> Bool {
    return (row >= 0 && row < grid.count) && (col >= 0 && col < grid[0].count) && (grid[row][col] != nil)
}

func FlashAll(mutableGrid grid: inout [[Int?]], pos: (row: Int, col: Int)) {
    
    var idx = pos
    //increase each adjacent position
    for adjacentPos in Adjacent.allCases {
        let adjDiff = adjacentPos.AddToPos
        let row = idx.row + adjDiff.0
        let col = idx.col + adjDiff.1
        //if valid idx add to grid (in bounds + not nil)
        if isValid(row: row, col: col, grid: grid) {
            grid[row][col]! += 1
        }
        
        idx = pos //reset position
    }
    
}

func PerformStep(octuArr grid: inout [[Int?]]) -> Int {
    //increase all vals by 1
    grid = grid.map({$0.map({$0! + 1})})
    //find next flash
    var flashPos = GetNextFlashPos(for: grid)
    //while next flash != nil
    while (flashPos != nil) {
        //perform flash + set self to nil
        FlashAll(mutableGrid: &grid, pos: flashPos!)
       
        grid[flashPos!.row][flashPos!.col] = nil
        //get next octu flash
        flashPos = GetNextFlashPos(for: grid)
    }
    
    var countFlashes = 0
    //set all nil vals to zero, count flashes
    grid = grid.map({$0.map({
        if $0 == nil {
            countFlashes += 1
            return 0
        }
        return $0
    })})
    return countFlashes
}

func RepeatTask(times: Int, arg: inout [[Int?]], task: (inout [[Int?]]) -> (Int)) -> Int {
    return (1...times).reduce(0, {$0 + task(&arg) + ($1 - $1)})
}
func findFirstStepAllFlash(grid: inout [[Int?]], stepFunc: (inout [[Int?]]) -> (Int)) -> Int {
    let numOctopuses = grid.count * grid[0].count
    var flashes = 0
    var stepNum = 0
    
    repeat {
        flashes = stepFunc(&grid)
        stepNum += 1
    }
    while flashes != numOctopuses
    
    return stepNum
}

var octuArr = parseDumboOctopusFile()

var testArr: [[Int?]] = [[5,4,8,3,1,4,3,2,2,3],
                         [2,7,4,5,8,5,4,7,1,1],
                         [5,2,6,4,5,5,6,1,7,3],
                         [6,1,4,1,3,3,6,1,4,6],
                         [6,3,5,7,3,8,5,4,7,8],
                         [4,1,6,7,5,2,4,6,4,5],
                         [2,1,7,6,8,4,1,7,2,1],
                         [6,8,8,2,8,8,1,1,3,4],
                         [4,8,4,6,8,4,8,5,5,4],
                         [5,2,8,3,7,5,1,5,2,6]]

//let countFlashesTest = RepeatTask(times: 100, arg: &octuArr, task: PerformStep)

//print("Num flashes after 100 steps \(countFlashesTest)")

let allFlashing = findFirstStepAllFlash(grid: &octuArr, stepFunc: PerformStep)

print("First step all flash together: \(allFlashing)")
