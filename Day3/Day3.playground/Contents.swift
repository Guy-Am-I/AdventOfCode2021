import Cocoa
import Foundation
import Darwin

let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day3/input.txt"

func parseFileToArr(filePath: String) -> [String]?
{
    let fileURL = URL(fileURLWithPath: filePath)
    
    do {
        let contents = try String(contentsOf: fileURL, encoding: .utf8)
        let arr = contents.components(separatedBy: "\n")
        
        return arr
    }
    catch {
        print("Error parsing file: \(filePath)")
    }
    
    return nil
}

var stringBinaryArr = parseFileToArr(filePath: filePath) ?? []
stringBinaryArr.removeLast()

/// Get Gamma epsilong values (each bit in gamma is most common bit in corresponding pos of all "numbers" in arr
/// - Parameter arr: String array of binary digits (must all be same len)
/// - Returns: Tuple of gamma epsilon represented in string binary form
func getGammaEpsilonAsStr(from arr: [String]) -> (String, String)
{
    //arr to hold sum of all bits in corresponding pos
    let binStringLen = arr[0].count
    var bitSumArr = Array(repeating: 0, count: binStringLen)
    
    for binString in arr {
        //go over string chars and update arr
        for (i, char) in binString.enumerated() {
            bitSumArr[i] += char.wholeNumberValue ?? 0
        }
    }
    
    var gammaAsStr = ""
    var epsilonAsStr = ""
    //create gamma string based on most common bits
    for bitOccur in bitSumArr {
        let zero = "0"
        let one = "1"
        if bitOccur < (arr.count / 2) {
            gammaAsStr += zero
            epsilonAsStr += one
        }
        else {
            gammaAsStr += one
            epsilonAsStr += zero
        }
    }
    
    return (gammaAsStr, epsilonAsStr)
}




let gamEps: (String, String) = getGammaEpsilonAsStr(from: stringBinaryArr)

let gammaAsDec = Int(gamEps.0, radix: 2) ?? 0
let epsilonAsDec = Int(gamEps.1, radix: 2) ?? 0
 
print("Sub Power Consumption = \(gammaAsDec * epsilonAsDec)")




/// get Oxygen or CO2 rating based on AOC task
/// - Parameters:
///   - stringBinArr: array of strings containing binary digits
///   - bitIdx: bit index for choosing which values to keep/discard from arr
///   - type: "most": keep "nums" with most common bit,
///          "least": keep "nums" with least common bit
/// - Returns: smaller array after filtering nums based on bitIdx
func getRating(stringBinArr: [String], at bitIdx: Int, for type: String) -> String {
    
    // base case
    if (stringBinArr.count == 1 || bitIdx >= stringBinArr[0].count) {
        return stringBinArr[0]
    }
    
    //get least/most common bit at given idx
    var bitOccur = 0
    for binString in stringBinArr {
         let bit = binString[binString.index(binString.startIndex, offsetBy: bitIdx)]
        bitOccur += bit.wholeNumberValue ?? 0
    }
    
    var filterBit = 0
    var mostCommonBit = 0
    
    if bitOccur == stringBinArr.count / 2 {
        filterBit = type == "most" ? 1 : 0
    } else {
        mostCommonBit = bitOccur < (stringBinArr.count / 2) ? 1 : 0
    }
    
    if (type == "most") {
        filterBit = mostCommonBit
    } else {
        filterBit = abs(mostCommonBit - 1)
    }
    
    //filter array (discard all values who dont have filterBit ar required index
    var filteredArr = [String]()
    
    for binString in stringBinArr {
        let bit = binString[binString.index(binString.startIndex, offsetBy: bitIdx)].wholeNumberValue ?? 0
        
        if bit == filterBit {
            filteredArr.append(binString)
        }
    }
    
    return getRating(stringBinArr: filteredArr, at: bitIdx + 1, for: type)
}

let oxygenRating = getRating(stringBinArr: stringBinaryArr, at: 0, for: "most")
let co2Rating = getRating(stringBinArr: stringBinaryArr, at: 0, for: "least")

let oxygenAsDec = Int(oxygenRating, radix: 2) ?? 0
let co2AsDec = Int(co2Rating, radix: 2) ?? 0

print("Life Support Rating = \(oxygenAsDec * co2AsDec)")
