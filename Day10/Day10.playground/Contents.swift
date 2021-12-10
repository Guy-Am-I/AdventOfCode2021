import Cocoa

/** Stack Impl in swift */
/*protocol Stackable {
    associatedtype Element
    func peek() -> Element?
    mutating func push(_ element: Element)
    @discardableResult mutating func pop() -> Element?
}

extension Stackable {
    var isEmpty: Bool { peek() == nil }
}

struct Stack<Element>: Stackable where Element: Equatable {
    private var storage = [Element]()
    func peek() -> Element? { storage.last }
    mutating func push(_ element: Element) { storage.append(element)  }
    mutating func pop() -> Element? { storage.popLast() }
}

extension Stack: Equatable {
    static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool { lhs.storage == rhs.storage }
}

extension Stack: CustomStringConvertible {
    var description: String { "\(storage)" }
}
    
extension Stack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Self.Element...) { storage = elements }
} */


let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day10/input.txt"

func fileLinesToStrArr() -> [String] {
    let url = URL(fileURLWithPath: filePath)
    
    guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
        return []
    }
    
    var linesArr = contents.components(separatedBy: "\n")
    linesArr.removeLast()
    
    return linesArr
}

func isPair(open: String, close: String) -> Bool {
    switch (open, close) {
    case ("(", ")"): return true
    case ("{", "}"): return true
    case ("[", "]"): return true
    case ("<", ">"): return true
    default: return false
    }
}

func GetPair(for symb: String) -> String {
    switch symb {
    case "{":
        return "}"
    case "(":
        return ")"
    case "<":
        return ">"
    case "[":
        return "]"
    default:
        print("Invalid symbol")
        return ""
    }
}

func CompleteOpenLine(_ uncompleted: [String]) -> [String] {
    return uncompleted.reversed().map({
        GetPair(for: $0)
    })
}

func GetScoreVal(for symbol: String) -> Int {
    switch symbol {
    case "}":
        return 3
    case ")":
        return 1
    case ">":
        return 4
    case "]":
        return 2
    default:
        print("Invalid symbol")
        return 0
    }

}

func CalcCompletionScore(for symbArr: [String]) -> Int {
    return symbArr.reduce(0, {
        ($0 * 5) + GetScoreVal(for: $1)
    })
}

func GetCorruptedSymbols(inputArr: [String]) -> ([String: Int], [Int]) {

    let openChars: Set = ["(", "{", "<", "["]
    let closeChars: Set = [")", "}", ">", "]"]
    var chunkOrderdChars: [String] = []
    var corruptionDict = [")": 0, "}": 0, "]": 0, ">": 0]
    var scoresArr: [Int] = []

    for chunk in inputArr {
        var flag = false
    symbolLoop: for symb in chunk {
            let char = String(symb)
            switch char {
            case let char where openChars.contains(char):
                chunkOrderdChars.append(char)
            case let char where closeChars.contains(char):
                let lastSymbol = chunkOrderdChars.removeLast()
                //pair or not pair
                if !isPair(open: lastSymbol, close: char) {
                    //FLAG CORRUPTED LINE
                    //update corruption dict [")": count, "}": count, ">": count, "]": count]
                    corruptionDict[char]? += 1 //only closing braces can corrupt line
                    flag = true
                    break symbolLoop
                }
            default:
                print("invalid symbol")
                return ([:], [])
            }
        }
        //IF NOT CORRUPTED
        if !flag {
            //COMPLETE Line
            let completion = CompleteOpenLine(chunkOrderdChars)
            //CALC COMPLETION SCORE
            let score = CalcCompletionScore(for: completion)
            //ADD SCORE TO RES ARR
            scoresArr.append(score)
        }
        //empty arr
        chunkOrderdChars = []
    }
    return (corruptionDict, scoresArr)
}

func GetSyntaxScore(for syntaxDict: [String: Int]) -> Int {
    var sum = 0
    
    for (key, value) in syntaxDict {
        switch key {
        case "]":
            sum += value * 57
        case "}":
            sum += value * 1197
        case ")":
            sum += value * 3
        case ">":
            sum += value * 25137
        default:
            print("Invalid Key in Dict")
        }
    }
    return sum
}

let linesArr = fileLinesToStrArr()

/*let linesArr =
["[({(<(())[]>[[{[]{<()<>>",
"[(()[<>])]({[<{<<[]>>(",
"{([(<{}[<>[]}>{[]{[(<()>",
"(((({<>}<{<{<>}{[]{[]{}",
"[[<[([]))<([[{}[[()]]]",
"[{[{({}]{}}([{[{{{}}([]",
"{<[[]]>}<{[{[{[]{()[[[]",
"[<(<(<(<{}))><([]([]()",
"<{([([[(<>()){}]>(<<{{",
"<{([{{}}[<[[[<>{}]]]>[]]"]*/

let results = GetCorruptedSymbols(inputArr: linesArr)

let syntaxSum = GetSyntaxScore(for: results.0)
let sortedScored = results.1.sorted()

print("Syntax score for chunks: \(syntaxSum)")

print("Middle Score for completion strings: \(sortedScored[sortedScored.count / 2])")
