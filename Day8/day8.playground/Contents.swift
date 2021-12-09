import Cocoa

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day8/input.txt"

/** Input: 10 signal Patters | 4 digit output */
/** Parse to array where each value is:
            ("String array of firsrt 10 patters + 4 digit output", string array of only digit output) */
func parseFileToArr() -> [([String], [String])] {
    let fileURL = URL(fileURLWithPath: filePath)
    
    var result = [([String], [String])]()
    
    if let contents = try? String(contentsOf: fileURL, encoding: .utf8) {
        var linesArr = contents.components(separatedBy: "\n")
        linesArr.removeLast()
        result = linesArr.map({
            let signalsArr = $0.components(separatedBy: "|")
            var digitOutputArr = signalsArr[1].components(separatedBy: " ")
            digitOutputArr.removeFirst() //removes first empty element
            var signalPatterns = signalsArr[0].components(separatedBy: " ")
            signalPatterns.removeLast() //remove last empty element
            signalPatterns += digitOutputArr
            
            return (signalPatterns, digitOutputArr)
        })
    }
    
    return result
}

func SharedCharsCount(for str1: String, and str2: String) -> Int {
    
    let oneChars = Set(Array(str1))
    let unMappedChars = Set(Array(str2))
    let sharedCount = oneChars.intersection(unMappedChars).count
    
    return sharedCount
}
// return 0-9 number encodings (order of chars doesn't matter) based on given
// set of encodings
func GetNumEncoding(signalPatterns: [String]) -> [Int: String] {
    var resDict = [Int: String]()
    
    //keep track of values not yet mapped
    var unMappedPatterns = signalPatterns
    
    // map 1, 4, 7, 8 since we know they have unique signal_length
    signalPatterns.forEach({
        var num: Int = 0
        let sigLen = $0.count
        
        switch sigLen {
        case 2:
            num = 1
        case 3:
            num = 7
        case 4:
            num = 4
        case 7:
            num = 8
        default:
            //must be 0/2/3/5/6/9
            return
        }
        
        if resDict[num] == nil {
            //key doesn't exist so we create it
            resDict[num] = $0
            //remove all num from unmapped vals
            unMappedPatterns.removeAll(where: {
                $0.count == sigLen
            })
        }
    })
    
    // 1,4,7,8 mapped -> handle 0,2,3,5,6,9
    unMappedPatterns.forEach({
        //pattern count either 5/6
        if ($0.count == 5) {
        //check how many digits pattern shares with 1
            if SharedCharsCount(for: $0, and: resDict[1]!) == 2 {
                //shares 2 with 1 => must be 3
                resDict[3] = $0
            } else {
                //share 1 with 1 (2,5)
                if SharedCharsCount(for: $0, and: resDict[4]!) == 3 {
                    //must be 5
                    resDict[5] = $0
                }
                else { resDict[2] = $0 }
            }
            
        } else if ($0.count == 6) {
            if SharedCharsCount(for: $0, and: resDict[1]!) == 1 {
                resDict[6] = $0
            } else {
                //share 1 with 1 (2,5)
                if SharedCharsCount(for: $0, and: resDict[4]!) == 4 {
                    //must be 5
                    resDict[9] = $0
                }
                else { resDict[0] = $0 }
            }
        } else {print("INVALID Signal Pattern lengtn")}
    })
    
    return resDict
}

func GetOutput(for digArr: [String], mapping: [Int:String]) -> String {
 
    let result = digArr.reduce("", {
        for (key, value) in mapping {
            if $1.count == value.count {
                let shared = SharedCharsCount(for: $1, and: value)
                if shared == $1.count {
                    return $0 + String(key)
                }
            }
        }
        return $0 + ""
    })
    
    return result
}

//for each tuple
    //get num encoding
    //decode digit output
//sum all results
let dataArr = parseFileToArr()
//let dataArr = [(["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab", "cdfeb", "fcadb", "cdfeb", "cdbaf"], ["cdfeb", "fcadb", "cdfeb", "cdbaf"])]
let finalSum = dataArr.reduce(0, {
    let numEncoding = GetNumEncoding(signalPatterns: $1.0)
    
    let output = GetOutput(for: $1.1, mapping: numEncoding)
    
    return $0 + (Int(output) ?? 0)
})
print("Total Sum = \(finalSum)")



/*let uniqueElems = digitOutArr.reduce(0, {
    let uniqueLens = Set([2,3,4,7])
    if uniqueLens.contains($1.count) {
        return $0 + 1
    }
    
    return $0
})

print("Num unique elems (1,4,7,8) = \(uniqueElems)")

//print(dataArr[0])
//print(dataArr[1])
/*for i in 0..<dataArr.count{
    let patArr = dataArr[i].0.components(separatedBy: " ")
    let testArr = patArr + dataArr[i].1
    
    let countOnes = testArr.reduce(0, {$0 + ($1.count == 7 ? 1 : 0)})
    print("pos \(i), Ones: \(countOnes)"
}*/
*/
