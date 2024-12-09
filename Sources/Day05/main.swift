//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

import Shared
import Foundation

final class SafetyManualUpdate {
    
    let pageAscendingRules: [Int: Set<Int>]
    let pageDescendingRules: [Int: Set<Int>]
    let pageUpdates: [[Int]]
    
    var validPageUpdates: Set<[Int]> = .init()
    var invalidPageUpdates: Set<[Int]> = .init()
    var fixedInvalidPageUpdates: Set<[Int]> = .init()

    
    init?(from rawData: String) {
        let splitData = rawData.components(separatedBy: "\n\n")
        guard let rawPageOrderingRules = splitData[safe: 0],
              let rawPageUpdates = splitData[safe: 1] else { return nil }
        
        var tmpPageAscendingRules: [Int: Set<Int>] = [:]
        var tmpPageDescendingRules: [Int: Set<Int>] = [:]
        
        rawPageOrderingRules.enumerateLines { line, _ in
            let rule = line.split(separator: "|").compactMap { Int($0) }
            tmpPageAscendingRules[rule[0], default: .init()].insert(rule[1])
            tmpPageDescendingRules[rule[1], default: .init()].insert(rule[0])
        }
        
        self.pageAscendingRules = tmpPageAscendingRules
        self.pageDescendingRules = tmpPageDescendingRules
        
        var tmpPageUpdates: [[Int]] = []
        rawPageUpdates.enumerateLines { line, _ in
            tmpPageUpdates.append(line.split(separator: ",").compactMap({ Int($0) }))
        }
        self.pageUpdates = tmpPageUpdates
        validatePageUpdates()
        fixInvalidPageUpdates()
    }
    
    func validatePageUpdates() {
        for pageUpdate in pageUpdates {
            let isValid = validatePageUpdate(pageUpdate)
            if isValid {
                validPageUpdates.insert(pageUpdate)
            } else {
                invalidPageUpdates.insert(pageUpdate)
            }
        }
    }
    
    func validatePageUpdate(_ pageUpdate: [Int]) -> Bool {
        var seenPages: Set<Int> = .init()
        for page in pageUpdate {
            seenPages.insert(page)
            if !seenPages.intersection(pageAscendingRules[page] ?? .init()).isEmpty {
                return false
            }
        }
        return true
    }
    
    func fixInvalidPageUpdates() {
        for pageUpdate in invalidPageUpdates {
            let sorted = pageUpdate.sorted { (page1, page2) in
                // Check if page1 should come before page2 based on the ascending rules
                if let ascRules = pageAscendingRules[page1], ascRules.contains(page2) {
                    return true
                }
                // Check if page1 should come after page2 based on the descending rules
                else if let descRules = pageDescendingRules[page1], descRules.contains(page2) {
                    return false
                }
                // If no rule exists, keep the original order
                return page1 < page2
            }
            fixedInvalidPageUpdates.insert(sorted)
        }
    }
    
    lazy var validPagesMiddleNumberSum: Int = {
        var result = 0
        for pageUpdate in validPageUpdates {
            result += pageUpdate[pageUpdate.count/2]
        }
        return result
    }()
    
    lazy var fixedInvalidPagesMiddleNumberSum: Int = {
        var result = 0
        for pageUpdate in fixedInvalidPageUpdates {
            result += pageUpdate[pageUpdate.count/2]
        }
        return result
    }()

}

guard let stringInput = getInputAsString(for: "day05") else {
    exit(1)
}

guard let safetyManualUpdate = SafetyManualUpdate(from: stringInput) else {
    exit(1)
}

print(safetyManualUpdate.validPagesMiddleNumberSum)
print(safetyManualUpdate.fixedInvalidPagesMiddleNumberSum)
