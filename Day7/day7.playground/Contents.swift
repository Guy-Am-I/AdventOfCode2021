import Cocoa

/* parse dict */
let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day7/input.txt"

func crabFileToDict(filePath: String) -> [String: Int] {

    var crabDict: [String: Int] = [:]

    let fileURL = URL(fileURLWithPath: filePath)

    guard let contents = try? String(contentsOf: fileURL, encoding: .utf8)
    else {
        return crabDict
    }

    /* remove trailing newline */
    let data = contents.trimmingCharacters(in: .newlines)
    /* array from contents */
    let crabArr = data.components(separatedBy: ",")
    /* map array to dict */

    crabArr.map({
        crabDict[$0, default: 0] += 1
    })



    return crabDict
}

let crabDict = crabFileToDict(filePath: filePath)

// get average
// search min - average (if closer to min)
// search average - max (if closer to max)
func getSearchRange(crabDict: [String: Int]) -> (Int, Int) {
    
    let sumVals: Double = Double(crabDict.reduce(0, {
        $0 + (Int($1.key)! * $1.value)
    }))
    
    let numCrabs = Double(crabDict.reduce(0, {
        $0 + $1.value
    }))
    
    let avg = Int((sumVals / numCrabs).rounded())
    
    let keyArr = crabDict.map({Int($0.key)!})
    
    let min = keyArr.min()!
    let max = keyArr.max()!
    
    if (max - avg > avg - min) {
        return (min, avg)
    }
    
    return (avg, max)
}

func calcFuel(crabDict: [String: Int], for pos: Int) -> Int {
    return crabDict.reduce(0, {
        //part 1 - each step costs 1 unit of fuel
        //$0 + abs((pos - Int($1.key)!) * $1.value)
        //part 2 - each step costs 1 more than last step (math series: 1+2+3...)
        let n = abs((pos - Int($1.key)!))
        let mathSum = (n*(n+1))/2
                    
        return $0 + (mathSum * $1.value)
    })
}

func getMinFuel(for dict: [String: Int], in search: (Int, Int)) -> Int {
    
    var minFuel : Int? = nil
    //keep track of min fuel until now
    //calc fuel for each pos
    for pos in search.0...search.1 {
        let posFuel = calcFuel(crabDict: dict, for: pos)
        if minFuel == nil || posFuel < (minFuel ?? 0) {
            minFuel = posFuel
        }
    }
    
    return minFuel!
}


//print(crabDict)
let range = getSearchRange(crabDict: crabDict)
let minFuel = getMinFuel(for: crabDict, in: range)

print("Min Fuel for Crabs is : \(minFuel)")
