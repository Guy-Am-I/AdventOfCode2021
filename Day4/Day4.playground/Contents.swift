import Cocoa
import Foundation

/*  ALGO
 *  Pare File
    * Put first line in array of bingo numbers
    * parse each board 1 at a time into bingo board collection
    * go over bingo-numbers 1 at a time:
        *update each board accordingly
        *check if any board won (only hor/ver)
            *end and calc result
 
 * Each Bingo board is a 2D array of (number: Int,  hasAppeared: bool)
 **/

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day4/input.txt"


/// Parse given string array into a 2d Array representation of Bingo Board
/// - Parameters:
///   - board: arr where each value is a horiz line in the board (count == 5)
/// - Returns: 2D array representing Bingo Board
func ParseBingoBoard(board lineArr: ArraySlice<String>) -> [[(String, Bool)]] {
    
    var board: [[(String, Bool)]] = []
    
    for line in lineArr {
        let numArr = line.split(separator: " ", maxSplits: 5, omittingEmptySubsequences: true)
        
        var boardLine: [(String, Bool)] = []
        
        for num in numArr {
            boardLine.append((String(num), false))
        }
        
        board.append(boardLine)
    }
    
    return board
}


/// calculate score for a given winning bingo board
/// - Parameter board: bingo board in our representation
/// - Parameter winNumber: number that made the board win
/// *formula: * sum of all unmarked numbers * winning number
/// - Returns: score based on formula
func CalcScore(board: [[(String, Bool)]], winNumber: Int) -> Int {
    
    var unmarkedSum = 0
    
    for row in board {
        row.forEach({
            if $0.1 == false {
                unmarkedSum += Int($0.0) ?? 0
        }})
    }
    
    return unmarkedSum * winNumber
}

/// Parse given Bingo Game text file into usable collections
/// - Parameter filePath: filePath to txt file containing Bingo info
/// - Returns: (Bingo Input numbers (as strings) in order they are drawn, Array of Bingo Boards (each board is a 2D array -> each element is tup: (Value as String, Flag to mark if its been drawn)
/// File must be of following format
/// 1st line: Bingo Numbers seperated by commas
/// *empty lines in between bingo boards*
/// Bingo Board (5 lines -> each line has 5 nums sep by space)
func parseBingoFile(filePath: String) -> ([String], [[[(String, Bool)]]]) {
    
    let fileURL = URL(fileURLWithPath: filePath)
    
    guard let contents = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return ([], []) }
        
    //Arr where each element is corresponding line in file
    let linesAsArr = contents.components(separatedBy: "\n")
    //Parse First Line into Bingo num arr
    let bingoNumbersArr = linesAsArr.first?.components(separatedBy: ",") ?? []
    
    //Parse rest of Arr into Bingo Boards arr
    var bingoBoardsArr: [[[(String, Bool)]]] = []
           
    //start at index 2 (start of first Bingo Board)
    //jump by 6 (to start of next bingo board
    for bingoStartIdx in stride(from: 2, to: linesAsArr.count, by: 6) {
        let board = ParseBingoBoard(board: linesAsArr[bingoStartIdx..<bingoStartIdx + 5])
        
        bingoBoardsArr.append(board)
    }
    
    return (bingoNumbersArr, bingoBoardsArr)
}

func CheckWin(for board: [[(String, Bool)]]) -> Bool {
    
    // check rows
    for row in board {
        if row.allSatisfy({$0.1 == true}) {
            return true
        }
    }
    //check cols
    for j in board[0].indices {
        var flag = true
        for i in board.indices {
            if board[i][j].1 == false {
                flag = false
                break
            }
        }
        if flag == true {return true}
    }
    
    return false
}

/// Play Bingo game for given boards with given inpu
/// - Parameters:
///   - boardsArr: array of Bingo Boards
///   - numArr: array of numbers to draw (in order)
/// - Returns: the board that won first and its winnign score
///     *If multiple boards win at same draw then the board that appears first in the array is declared the winner*
func PlayBingo(for boardsArr: [[[(String, Bool)]]], with numArr: [String]) -> ([[(String, Bool)]], Int) {
        
    var boardsCpy = boardsArr //copy boards to update them
    var wonBoards: [Bool] = Array(repeating: false, count: boardsArr.count) // keep track how many boards won
    
    for num in numArr {
        //update each board
        for (boardIdx, board) in boardsArr.enumerated() {
            //update board with num
            for (rowIdx, row) in board.enumerated() {
                if let numIdx = row.firstIndex(where: {$0.0 == num}) {
                    boardsCpy[boardIdx][rowIdx][numIdx].1 = true
                }
            }
            /* check only if board hasnt won alrdy */
            if wonBoards[boardIdx] == false && CheckWin(for: boardsCpy[boardIdx]) == true {
                wonBoards[boardIdx] = true
                /* PART 1: return winning board */
                /* PART 2: find last board to win */
                if wonBoards.allSatisfy({$0 == true}) {
                    let score = CalcScore(board: boardsCpy[boardIdx], winNumber: Int(num) ?? 0)
                    return (boardsCpy[boardIdx], score)
                }
                
            }
        }
    }
    
    return ([], 0)
}


let bingoData = parseBingoFile(filePath: filePath)

/*
let winningBoard = PlayBingo(for: bingoData.1, with: bingoData.0)

print("winning score is \(winningBoard.1)")
*/

let lastBoardToWin = PlayBingo(for: bingoData.1, with: bingoData.0)

print("Last Board to win score is \(lastBoardToWin.1)")
