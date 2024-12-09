//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

/*
 --- Day 4: Ceres Search ---
 https://adventofcode.com/2024/day/4
 */

import Shared
import Foundation


final class WordSearch: CustomStringConvertible {
    // table[row][col] to look up char
    let table: [[String]]
    
    init(from rawData: String) {
        var tmp: [[String]] = []
        rawData.enumerateLines { line, _ in
            tmp.append(line.map { String($0) })
        }
        table = tmp
    }
    
    func getWordCount(for word: String) -> Int {
        var result = 0
        for row in 0...table.count-1 {
            for col in 0...table[row].count-1 {
                if table[row][col] == String(word.first!) {
                    result += findWord(word, startingIndex: (row, col))
                }
            }
        }
        
        return result
    }
    
    func countX_MAS() -> Int {
        var result = 0
        for row in 1...table.count-2 {
            for col in 1...table[row].count-2 {
                if table[row][col] == "A" {
                    // check if this is an "X-MAS"
                    let topLeft = table[row-1][col-1]
                    let bottomRight = table[row+1][col+1]
                    let topRight = table[row-1][col+1]
                    let bottomLeft = table[row+1][col-1]
                    
                    switch (topLeft, bottomRight, topRight, bottomLeft) {
                    case ("M", "S", "M", "S"), ("M", "S", "S", "M"), ("S", "M", "M", "S"), ("S", "M", "S", "M"):
                        result += 1
                    default:
                        continue
                    }
                }
            }
        }
        
        return result
    }
    
    private func findWord(_ word: String, startingIndex: (Int, Int)) -> Int {
        rowSearch(startingIndex: startingIndex, word: word) + colSearch(startingIndex: startingIndex, word: word) + diagonalSearch(startingIndex: startingIndex, word: word)
    }
    
    private func rowSearch(startingIndex index: (Int, Int), word: String) -> Int {
        var result = 0
        let word = word.map { String($0) }
        guard table[safe: index.0]?[safe: index.1] == word[safe: 0],
              let row = table[safe: index.0] else { return 0 }
        
        // Search Backward
        var currSearchIndex = 1
        var currColIndex = index.1
        while currSearchIndex < word.count && currColIndex >= 0 {
            currColIndex -= 1
            if row[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }

        // Search Forward
        currSearchIndex = 1
        currColIndex = index.1
        while currSearchIndex < word.count && currColIndex < row.count {
            currColIndex += 1
            if row[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }

        return result
    }
    
    private func colSearch(startingIndex index: (Int, Int), word: String) -> Int {
        var result = 0
        let word = word.map { String($0) }
        let col = index.1
        guard table[safe: index.0]?[safe: index.1] == word[safe: 0] else { return 0 }
        
        // Search Upward
        var currSearchIndex = 1
        var currRowIndex = index.0
        while currSearchIndex < word.count && currRowIndex >= 0{
            currRowIndex -= 1
            if table[safe: currRowIndex]?[safe: col] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }

        // Search Forward
        currSearchIndex = 1
        currRowIndex = index.0
        while currSearchIndex < word.count && currRowIndex < table.count {
            currRowIndex += 1
            if table[safe: currRowIndex]?[safe: col] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }

        return result
    }
    
    private func diagonalSearch(startingIndex index: (Int, Int), word: String) -> Int {
        var result = 0
        let word = word.map { String($0) }
        guard table[safe: index.0]?[safe: index.1] == word[safe: 0] else { return 0 }
        
        // Search Top Left Diagonal
        var currSearchIndex = 1
        var currRowIndex = index.0
        var currColIndex = index.1
        while currSearchIndex < word.count && currColIndex >= 0 && currColIndex >= 0 {
            currRowIndex -= 1
            currColIndex -= 1
            if table[safe: currRowIndex]?[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }
        
        // Search Top Right Diagonal
        currSearchIndex = 1
        currRowIndex = index.0
        currColIndex = index.1
        while currSearchIndex < word.count && currRowIndex >= 0 && currColIndex < table[index.0].count {
            currRowIndex -= 1
            currColIndex += 1
            if table[safe: currRowIndex]?[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }
 
        // Search Bottom Left Diagonal
        currSearchIndex = 1
        currRowIndex = index.0
        currColIndex = index.1
        while currSearchIndex < word.count && currColIndex >= 0 && currRowIndex < table.count {
            currRowIndex += 1
            currColIndex -= 1
            if table[safe: currRowIndex]?[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }
        
        // Search Bottom Right Diagonal
        currSearchIndex = 1
        currRowIndex = index.0
        currColIndex = index.1
        while currSearchIndex < word.count && currColIndex < table[index.0].count && currRowIndex < table.count {
            currRowIndex += 1
            currColIndex += 1
            if table[safe: currRowIndex]?[safe: currColIndex] == word[safe: currSearchIndex] {
                currSearchIndex += 1
                if currSearchIndex == word.count {
                    result += 1
                }
            } else {
                break
            }
        }

        return result
    }
    
    var description: String {
        var description = ""
        for row in table {
            description += "\(row.map { $0 }.joined())\n"
        }
        return description
    }
}

guard let stringInput = getInputAsString(for: "day04") else {
    exit(1)
}

let wordSearch = WordSearch(from: stringInput)

print("Solution to Part 1: \(wordSearch.getWordCount(for: "XMAS"))")
print()
print("Solution to Part 2: \(wordSearch.countX_MAS())")


