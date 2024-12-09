//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

/*
 --- Day 3: Mull It Over ---
 https://adventofcode.com/2024/day/3
 */

import Shared
import Foundation

let multCommandPattern = /mul\(\d+,\d+\)/
let conditionalMultCommandPattern = /mul\(\d+,\d+\)|do\(\)|don't\(\)/

@MainActor
func getMatchingSubstrings(from input: String, with pattern: Regex<Substring>) -> [String] {
    let matches = input.matches(of: pattern)
    return matches.map { match in
        String(match.output)
    }
}

func extractAllNumbers(from input: String) -> [Int] {
    // Use components(separatedBy:) to split the string by non-digit characters
    let numbers = input.split { !$0.isNumber }
        .compactMap { Int($0) } // Convert substrings to integers
    
    return numbers
}

@MainActor
func parseAllMultiplactionCommands(from stringInput: String) -> Int {
    let multiplactionCommands = getMatchingSubstrings(
        from: stringInput,
        with: multCommandPattern
    )
    var result = 0
    for command in multiplactionCommands {
        let numbers = extractAllNumbers(from: command)
        result += numbers.reduce(into: 1) { result, next in result *= next }
    }
    return result
}

@MainActor
func parseConditionalMultiplactionCommands(from stringInput: String) -> Int {
    let multiplactionCommands = getMatchingSubstrings(
        from: stringInput,
        with: conditionalMultCommandPattern
    )
    var result = 0
    var isOn = true
    for command in multiplactionCommands {
        if command == "do()" {
            isOn = true
        } else if command == "don't()" {
            isOn = false
        }
        let numbers = extractAllNumbers(from: command)
        if isOn && numbers.count != 0 {
            result += numbers.reduce(into: 1) { result, next in result *= next }
        }
    }
    return result
}

guard let stringInput = getInputAsString(for: "day03") else {
    exit(1)
}

print("Solution to Part 1: \(parseAllMultiplactionCommands(from: stringInput))")
print()
print("Solution to Part 2: \(parseConditionalMultiplactionCommands(from: stringInput))")

