import Cocoa
import Foundation
let filename = "input.txt"

func ReadFile(filename: String) -> String {
    
    var res = ""
    //Read file
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    {
        let fileURL = dir.appendingPathComponent(filename)
        
        do {
            print("URL: \(fileURL)")
            res = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch
        {
            res = "error"
        }
    }
    
    return res
}

func NumValsBiggerThanPrev(_ sequence: String) -> Int {
    
    let val_arr = sequence.split(separator: "\n")
    
    var count = 0
    var prev_window = Int(String(val_arr[0]))! + Int(String(val_arr[1]))! + Int(String(val_arr[2]))!
    
    for i in 0...(val_arr.count - 3)
    {
        let next_Window = Int(String(val_arr[i]))! + Int(String(val_arr[i + 1]))! + Int(String(val_arr[i + 2]))!
        
        if next_Window > prev_window {
            count += 1
        }
        
        prev_window = next_Window
    }
    
    return count
}
    
//iterate over nums
let file = ReadFile(filename: filename)

print("Resi \(NumValsBiggerThanPrev(file))")
