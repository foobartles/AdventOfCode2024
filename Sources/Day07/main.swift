//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/9/24.
//

/*
 --- Day 7: Bridge Repair ---
 https://adventofcode.com/2024/day/7
 */

import Foundation
import Shared
import DequeModule

// Concat operator
infix operator ><: MultiplicationPrecedence
extension Int {
    static func >< (lhs: Int, rhs: Int) -> Int {
        return Int(String(lhs) + String(rhs))!
    }
}

struct IncompleteCalibrationEquation: CustomStringConvertible {
    let solution: Int
    let terms: Deque<Int>
    
    init(solution: Int, terms: [Int]) {
        self.solution = solution
        self.terms = Deque(terms)
    }
    
    func determineIfPotentiallyValid() -> Bool {
        var terms = self.terms
        guard let first = terms.popFirst() else { return false}
        return recurse(current: first, remainingTerms: terms)
        || recurse(current: first, remainingTerms: terms)
        || recurse(current: first, remainingTerms: terms)
    }
    
    func recurse(current: Int, remainingTerms: Deque<Int>) -> Bool {
        // exit early if we have gone over solution value
        guard current <= solution else { return false }
        // check if we have solved the equation
        if remainingTerms.isEmpty {
            return current == solution
        }
        var remaining = remainingTerms
        if let nextTerm = remaining.popFirst() {
            return recurse(current: current + nextTerm, remainingTerms: remaining)
            || recurse(current: current * nextTerm, remainingTerms: remaining)
            || recurse(current: current >< nextTerm, remainingTerms: remaining)
        } else { return false }
    }
    
    var description: String {
        "\(solution): " + terms.map { String($0) }.joined(separator: " ")
    }
}

guard let stringInput = getInputAsString(for: "day07") else {
    exit(1)
}

var equations: [IncompleteCalibrationEquation] = []
stringInput.enumerateLines { line, _ in
    let splitLine = line.split(separator: ":")
    guard let solution = Int(splitLine[0]) else {
        exit(1)
    }
    let terms = splitLine[1].split(separator: " ").map { num in
        guard let unwrappedInt = Int(num) else { exit(1) }
        return unwrappedInt
    }
    equations.append(IncompleteCalibrationEquation(solution: solution, terms: terms))
}


print("\(equations.filter { $0.determineIfPotentiallyValid() }.reduce(0) { $0 + $1.solution })")



