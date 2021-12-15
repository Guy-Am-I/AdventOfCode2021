//#!/usr/bin/swift

import Cocoa

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day14/input.txt"

/*Parse file: return (template as a string arr, rules as dict[pair: new 3 char sequence with insetion */
func parseFile() -> ([String: Int64], [String: (String, String)]) {
    
    let url = URL(fileURLWithPath: filePath)
    
    let contents = try! String(contentsOf: url, encoding: .utf8)
    var linesArr = contents.components(separatedBy: "\n")
    
    let templateArr = linesArr[0].map({String($0)})
    var pairsDict: [String: Int64] = [:]
    //extract paris from templateArr
    for idx in 0..<(templateArr.count - 1) {
        let pair = templateArr[idx...(idx+1)].joined()
        pairsDict[pair, default: 0] += 1
    }
    
    
    linesArr.removeSubrange(0..<2)
    linesArr.removeLast()
    var dict: [String: (String, String)] = [:]
    
    linesArr.forEach({
        let pairValArr = $0.components(separatedBy: " -> ")
        let pair = pairValArr[0]
        let res1 = pair[...pair.startIndex] + String(pairValArr[1].first!)
        let res2 = String(pairValArr[1].first!) + pair[pair.index(after: pair.startIndex)...]
        
        dict[pairValArr[0]] = (String(res1), res2)
    })
    
    return (pairsDict, dict)
}

func PerformStep(polymer polymerDict: [String: Int64], insertionRules ruleDict: [String: (String, String)]) -> [String: Int64] {
    
    var copyDict = polymerDict
    
    //split all pairs from polymer
    polymerDict.forEach({
        let pairOccur = $0.value
        
        if let pair1 = ruleDict[$0.key]?.0, //must be rule for each pair
                let pair2 = ruleDict[$0.key]?.1 {
            copyDict[pair1, default: 0] += pairOccur
            copyDict[pair2, default: 0] += pairOccur
            //get all pair vals from dict
            copyDict[$0.key, default: 0] -= pairOccur
        }
    })
    
    return copyDict
}

let data = parseFile()
//print("polymer pairs: \(data.0), rules: \(data.1)")
var res = data.0
let num = 40

//repeat task
(1...num).forEach({num in
    res = PerformStep(polymer: res, insertionRules: data.1)
})

var appearanceDict = [String: Int64]()
let firstlet = String(res.first!.key.first!)
appearanceDict[firstlet, default: 0] += 1
res.forEach({
    var cpy = $0.key
    cpy.removeFirst()
    let let2 = String(cpy.removeFirst())
//    appearanceDict[let1, default: 0] += $0.value
    appearanceDict[let2, default: 0] += $0.value
})

print(appearanceDict)
//most common
let mostCommon = appearanceDict.max(by: {$0.value < $1.value})!
//least common
let leastCommon = appearanceDict.min(by: {$0.value < $1.value})!

print("final result = \(mostCommon.value - leastCommon.value) ☃️")


//print("least common: \(leastCommon)")
//print("most common: \(mostCommon)")


//print("After \(num) steps: \(res)")
