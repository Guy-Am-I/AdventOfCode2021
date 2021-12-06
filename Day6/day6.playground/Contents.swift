import Cocoa
/** Day 6 : Lanternfish **/

/* parse file into key:value dict
 ["fish timer": # fishes] */

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day6/input.txt"

func fishFileToDict(filePath: String) -> [String: Int] {
    
    var fishDict: [String: Int] = [:]
    
    let fileURL = URL(fileURLWithPath: filePath)
    
    guard let contents = try? String(contentsOf: fileURL, encoding: .utf8)
    else {
        return fishDict
    }
    
    /* remove trailing newline */
    let data = contents.trimmingCharacters(in: .newlines)
    /* array from contents */
    let fishArr = data.components(separatedBy: ",")
    /* map array to dict */
    
    fishArr.map({
        fishDict[$0, default: 0] += 1
    })
    
    
    
    return fishDict
}

func repeatCode(amount: Int, dict: [String: Int], code: ([String: Int]) -> [String: Int]) -> [String: Int] {
    
    var resDict = dict
    
    for _ in 1...amount {
        resDict = code(resDict)
    }
    
    return resDict
}

func updateFishDict(dict: [String: Int]) -> [String: Int] {
    var resDict = [String: Int]()
    /* for each dict entry */
    dict.map({
        if ($0.key == "0") {
            resDict["8", default: 0] = $0.value
            resDict["6", default: 0] += $0.value
        }
        else {
            let oneLessKey = String((Int($0.key) ?? 0) - 1)
            resDict[oneLessKey, default: 0] += $0.value
        }
    })
    /* each key becomes "1" less */
    /* if key was zero it spawns value amount of 8's */
    
    return resDict
}

let fishDict = fishFileToDict(filePath: filePath)

//let fishDict = ["3": 2, "1": 1, "4": 1, "2": 1]

/* part 1 */
//let resDict = repeatCode(amount: 80, dict: fishDict, code: updateFishDict)
/* part 2*/
let resDict = repeatCode(amount: 256, dict: fishDict, code: updateFishDict)
/* count sum all values */
let sum2 = resDict.values.reduce(0, +)
