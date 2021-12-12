import Cocoa

/** Map connections using dict:
    key is node, value is a list of nodes it connects to */


let filePath = "/Users/guyguy/Documents/GitHub.nosync/AdventOfCode2021/Day12/input.txt"
/** ALGO */

//begin @ start key
    //for each node in it's list (add node to the path)
        //if wer'e at END - print/add to counter
        //otherwise visit all node in it's list:
            //if node is lowercase and alrdy in path return INVALID PATH
            //otherwise add it to path and recursively do the same for all nodes in it's list

func ParseFileToMapDict() -> [String: [String]] {
    let url = URL(fileURLWithPath: filePath)
    
    guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
        return [:]
    }
    
    var linesArr = contents.components(separatedBy: "\n")
    linesArr.removeLast()
    
    var mapDict = [String: [String]]()
    
    linesArr.forEach({
        let nodes = $0.components(separatedBy: "-")
        
        switch (nodes[0], nodes[1]) {
        case ("start", _):
            mapDict[nodes[0], default: []].append(nodes[1])
        case (_, "start"):
            mapDict[nodes[1], default: []].append(nodes[0])
        case ("end", _):
            mapDict[nodes[1], default: []].append(nodes[0])
        case (_, "end"):
            mapDict[nodes[0], default: []].append(nodes[1])
        default:
            mapDict[nodes[0], default: []].append(nodes[1])
            mapDict[nodes[1], default: []].append(nodes[0])
        }
    })
    
    return mapDict
}

var totalPaths = 0
func PrintAllPaths(mapDict: [String: [String]], currNode: String, currPath: [String], flag: Bool) {
    if (currNode == "end") {
        //print("Success: \(currPath)") Printing takes tooooo long....
        totalPaths += 1
        return
    }
    
    let connectedNodes = mapDict[currNode]
    connectedNodes?.forEach({
        //Can visit a single small cave twice!
        if ($0 == $0.lowercased() && currPath.contains($0)) {
            if flag == false {
                PrintAllPaths(mapDict: mapDict, currNode: $0, currPath: currPath + [$0], flag: true)
            }
        }
        else {
            PrintAllPaths(mapDict: mapDict, currNode: $0, currPath: currPath + [$0], flag: flag)
        }
    })
}
func FindAllPaths(mapDict: [String: [String]]) {
    PrintAllPaths(mapDict: mapDict, currNode: "start", currPath: ["start"], flag: false)
}

let mapDict = ParseFileToMapDict()

FindAllPaths(mapDict: mapDict)
print("Total Valid Paths = \(totalPaths)")
