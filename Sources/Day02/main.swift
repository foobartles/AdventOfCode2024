//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

/*
 --- Day 2: Red-Nosed Reports ---
 https://adventofcode.com/2024/day/2
 */

import Shared
import Foundation

// Safe Report Requirements:
// Any two adjacent levels differ by at least one and at most three.
// The levels are either all increasing or all decreasing.
class Report: CustomStringConvertible {
    private let rawData: String
    let levels: [Int]
    var removedLevel: Int?
    init?(from rawData: String) {
        self.rawData = rawData
        let parsedData = rawData.split(separator: " ").map { Int($0) ?? -1 }
        if parsedData.contains(-1) {
            print("⚠️ Non-int found in data")
            return nil
        }
        self.levels = parsedData
    }
    
    var isSafe: Bool {
        checkIfSafe(self.levels)
    }
    
    var isSafeWithProblemDampener: Bool {
        // anything already safe will be safe with dampener logic
        guard !isSafe else { return true }
        
        var dampenedLevels = levels
        for i in 0...levels.count-1 {
            dampenedLevels.remove(at: i)
            if checkIfSafe(dampenedLevels) {
                removedLevel = levels[i]
                return true
            }
            dampenedLevels = levels
        }
        
        return false
    }
    
    func checkIfSafe(_ levels: [Int]) -> Bool {
        // check if it should be always increase or always decreasing by comparing first and last elements
        let isIncreasing = levels.first ?? Int.min < levels.last ?? Int.max
        for i in 1...levels.count-1 {
            // Check that any two adjacent levels differ by at least one and at most three.
            let difference = abs(levels[i-1] - levels[i])
            if difference < 1 || difference > 3 {
                return false
            }
            // Ensure the levels are either all increasing or all decreasing.
            if (levels[i-1] < levels[i] && !isIncreasing) || (levels[i-1] > levels[i] && isIncreasing) {
                return false
            }
        }
        return true
    }
    
    var description: String {
        levels.map { "\($0)" }
            .joined(separator: " ")
            .appending(" - \(isSafe ? "✅ Safe" : "❌ UNSAFE")")
    }
    
    var dampenerDescription: String {
        levels.map { "\($0)" }
            .joined(separator: " ")
            .appending(" - \(isSafeWithProblemDampener ? "✅ Safe\(removedLevel != nil ? "with removed level \(removedLevel!)" : "")" : "❌ UNSAFE")")
    }
}

extension Array where Element == Report {
    var description: String {
        self.map { $0.description }.joined(separator: "\n")
    }
    
    var safeReportCount: Int {
        self.count(where: { $0.isSafe })
    }
    
    var safeReportCountWithProblemDampener: Int {
        self.count(where: { $0.isSafeWithProblemDampener })
    }
}

guard let stringInput = getInputAsString(for: "day02") else {
    exit(1)
}

var reports: [Report] = []

stringInput.enumerateLines { line, _ in
    guard let report = Report(from: line) else {
        exit(1)
    }
    reports.append(report)
}

print("Solution to Part 1: \(reports.safeReportCount)")
print()
print("Solution to Part 2: \(reports.safeReportCountWithProblemDampener)")
