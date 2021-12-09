import Cocoa

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day9/input.txt"

func parseFileToMatrix() -> [[Int]] {
    
    let url = URL(fileURLWithPath: filePath)
    
    var res = [[Int]]()
    
    guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
        return res
    }
    
    var linesArr = contents.components(separatedBy: "\n")
    linesArr.removeLast()
    linesArr.forEach({
        res.append($0.map({$0.wholeNumberValue!}))
    })
    
    return res
}

func SumLowPoints(matrix: [[Int]]) -> [(Int, Int)] {
//    var sumLows = 0
    var lowIndices: [(Int, Int)] = []
    let rows = matrix.count
    let cols = matrix[0].count
    
    for row in 0..<rows {
        for col in 0..<cols {
            let curr = matrix[row][col]
            //init to 10 since highest number in matrix is a digit (9)
            var up = 9, down = 9, left = 9, right = 9
            
            
            if col - 1 >= 0 {
                left = matrix[row][col - 1]
            }
            if (col + 1) < cols {
                right = matrix[row][col + 1]
            }
            if row - 1 >= 0 {
                up = matrix[row - 1][col]
            }
            if row + 1 < rows {
                down = matrix[row + 1][col]
            }
        
            if curr != 9 && curr == min(curr, down, left, up, right) {
                //Part 1: Sum low point risk levels
//                sumLows += curr + 1
                
                //Part 2: need indecies of low points
                lowIndices.append((row, col))
            }
        }
    }
    
    return lowIndices
}

func CountHelperRecur(point: (Int, Int), matrix: [[Int]], markings: inout [[Bool]]) -> Int {
    
    let row = point.0
    let col = point.1
    let rows = matrix.count
    let cols = matrix[0].count
    
    let curr = matrix[row][col]
    var sum = 1
    
    //try left
    if col - 1 >= 0 && markings[row][col - 1] == false {
        let left = matrix[row][col - 1]
        if left != 9 && left > curr {
            markings[row][col - 1] = true
            sum += CountHelperRecur(point: (row, col - 1), matrix: matrix, markings: &markings)
        }
    }
    //try right
    if (col + 1) < cols && markings[row][col + 1] == false{
        let right = matrix[row][col + 1]
        if right != 9 && right > curr {
            markings[row][col + 1] = true
            sum += CountHelperRecur(point: (row, col + 1), matrix: matrix, markings: &markings)
        }
    }
    //try up
    if row - 1 >= 0 && markings[row - 1][col] == false{
        let up = matrix[row - 1][col]
        if up != 9 && up > curr {
            markings[row - 1][col] = true
            sum += CountHelperRecur(point: (row - 1, col), matrix: matrix, markings: &markings)
        }
    }
    //try down
    if row + 1 < rows && markings[row + 1][col] == false {
        let down = matrix[row + 1][col]
        if down != 9 && down > curr {
            markings[row + 1][col] = true
            sum += CountHelperRecur(point: (row + 1, col), matrix: matrix, markings: &markings)
        }
    }
    
    return sum
}

func countBasinSize(lowPoint: (Int, Int), matrix: [[Int]], markedMatrix: inout [[Bool]]) -> Int {
    var size = 0
    
    size = CountHelperRecur(point: lowPoint, matrix: matrix, markings: &markedMatrix)
    
    return size
}


let dataMatrix = parseFileToMatrix()

let testMatrix = [[2,1,9,9,9,4,3,2,1,0],
                  [3,9,8,7,8,9,4,9,2,1],
                  [9,8,5,6,7,8,9,8,9,2],
                  [8,7,6,7,8,9,6,7,8,9],
                  [9,8,9,9,9,6,5,6,7,8]]

let LowPointsIdx = SumLowPoints(matrix: dataMatrix)
//print("Sum risk Lvl of all points: \(sumLowPoints)")
var markings: [[Bool]] = Array(repeating: Array(repeating: false, count: 101), count: 101)


var basinArr = LowPointsIdx.map({
    countBasinSize(lowPoint: $0, matrix: dataMatrix, markedMatrix: &markings)
})

//find 3 largest elements in arr + mult them
let max1 = basinArr.max()
basinArr.remove(at: basinArr.firstIndex(of: max1!)!)
let max2 = basinArr.max()
basinArr.remove(at: basinArr.firstIndex(of: max2!)!)
let max3 = basinArr.max()
basinArr.remove(at: basinArr.firstIndex(of: max3!)!)

print("Product of 3 largest basins = \(max1! * max2! * max3!)")
