//
//  Day1.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

import Shared
import Foundation

/*
 --- Day 1: Historian Hysteria ---
 https://adventofcode.com/2024/day/1
 */

final class SideBySideLocationIds: CustomStringConvertible {
    private var leftSide: [Int]
    private let leftSideSorted: [Int]
    private var leftSideCountDict: [Int: Int] = [:]
    
    private var rightSide: [Int]
    private let rightSideSorted: [Int]
    private var rightSideCountDict: [Int: Int] = [:]

    init?(input: String) {
        var tempLeft: [Int] = []
        var tempRight: [Int] = []
        input.enumerateLines { line, _ in
            let splitLine = line.split(separator: " ")
            guard let leftListItem = splitLine.first, let rightListItem = splitLine.last,
                  let leftListInt = Int(leftListItem), let rightListInt = Int(rightListItem) else { return }
            tempLeft.append(leftListInt)
            tempRight.append(rightListInt)
        }
        guard tempLeft.count == tempRight.count else { return nil }
        leftSide = tempLeft
        leftSideSorted = tempLeft.sorted()
        for id in leftSide {
            leftSideCountDict[id, default: 0] += 1
        }
        
        rightSide = tempRight
        rightSideSorted = tempRight.sorted()
        for id in rightSide {
            rightSideCountDict[id, default: 0] += 1
        }
    }
    
    // Solution for Part 1
    lazy var distanceBetweenLists: Int = {
        var totalDistance = 0
        for i in 0...leftSideSorted.count-1 {
            totalDistance += abs(leftSideSorted[i] - rightSideSorted[i])
        }
        return totalDistance
    }()
    
    // Solution for Part 2
    lazy var similarityBetweenLists: Int = {
        var similarityScore = 0
        for id in leftSide {
            let rightSideCount = rightSideCountDict[id] ?? 0
            similarityScore += id * rightSideCount
        }
        return similarityScore
    }()
    
    var description: String {
        var description = ""
        for i in 0...leftSideSorted.count-1 {
            description.append("\(leftSideSorted[i])        \(rightSideSorted[i])\n")
        }
        return description
    }
}

guard let stringInput = getInputAsString(for: "day01") else {
    exit(1)
}
guard let sideBySideLocationIds = SideBySideLocationIds(input: stringInput) else {
    print("⚠️ Errror initializing SideBySideLocationIds struct")
    exit(1)
}

print("Solution to Part 1: \(sideBySideLocationIds.distanceBetweenLists)")
print()
print("Solution to Part 2: \(sideBySideLocationIds.similarityBetweenLists)")
