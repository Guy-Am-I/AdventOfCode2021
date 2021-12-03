import Cocoa
import Foundation
/** read file
for each line
    //split to action : amount
    // switch case on action
        //update DEPTH or HORIZ
**/
//calc DEPTH * HORIZ

let input_path = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day2/input.txt"

func parseTextFile(filepath: String) -> [String]?
{
    let fileURL = URL(fileURLWithPath: filepath)
    
    if let contents = try? String(contentsOf: fileURL, encoding: .utf8) {
        
        let s_arr = contents.components(separatedBy: "\n")
        
        return s_arr
    }
    
    return nil
}

func GetDepthHoriz(_ string_arr: [String]) -> (Int, Int)
{
    var depth = 0
    var horiz = 0
    var aim = 0
    
    for line in string_arr {
        let sep_arr = line.components(separatedBy: " ")
        
        let command = sep_arr[0]
        let val = sep_arr.count > 1 ? Int(sep_arr[1]) ?? 0 : 0
        
        switch command {
        case "forward":
            horiz += val
            depth += (aim * val)
        case "down":
            aim += val
        case "up":
            aim -= val
        default:
            print("Bad COmmand \(command)")
        }
    }
    
    return (depth, horiz)
}

let lines: [String] = parseTextFile(filepath: input_path) ?? []
/* Depth above 0 ?*/
let result = GetDepthHoriz(lines)
print(result)
print(result.0 * result.1)

