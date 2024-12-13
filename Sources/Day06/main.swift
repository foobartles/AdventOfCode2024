//
//  main.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/9/24.
//

/*
 --- Day 6: Guard Gallivant ---
 https://adventofcode.com/2024/day/6
 */

import Shared
import Foundation

enum GuardDirection: String {
    case up = "^"
    case right = ">"
    case down = "v"
    case left = "<"
    
    func turn90Degrees() -> GuardDirection {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }
}

final class LabMap: CustomStringConvertible {
    private static let OBSTACLE = "#"
    private static let loopStepLimit = 4
    let initialMap: [[String]]
    let initalGuardPosition: Coordinate
    let initalGuardDirection: GuardDirection
    var uniqueGuardPositions: Set<Coordinate> = .init()
    
    init?(from rawData: String) {
        var tmpMap: [[String]] = []
        var tmpGuardPosition: Coordinate = .init(0, 0)
        var tmpGuardDirectioon: GuardDirection = .up
        
        var rowNumber = 0
        rawData.enumerateLines { line, _ in
            if let guardDirection = line.findGuardDirection() {
                tmpGuardDirectioon = guardDirection
            }
            let currentRow = line.map { String($0) }
            if let guardIndex = currentRow.guardIndex {
                tmpGuardPosition = .init(rowNumber, guardIndex)
            }
            tmpMap.append(currentRow)
            rowNumber += 1
        }
        
        self.initialMap = tmpMap
        self.initalGuardPosition = tmpGuardPosition
        self.initalGuardDirection = tmpGuardDirectioon
        
        predictGuardPatrol()
    }
    
    private func predictGuardPatrol() {
        var map: [[String]] = initialMap
        var guardPosition = initalGuardPosition
        var guardDirection = initalGuardDirection

        while guardPosition.row >= 0 && guardPosition.row < initialMap.count
                && guardPosition.col >= 0 && guardPosition.col < initialMap[0].count {
            let nextPosition = guardPosition.getNextGuardPosition(direction: guardDirection)
            if map[nextPosition] == LabMap.OBSTACLE {
                guardDirection = guardDirection.turn90Degrees()
                map[guardPosition] = guardDirection.rawValue
            } else {
                uniqueGuardPositions.insert(nextPosition)
                map[guardPosition] = "."
                map[nextPosition] = guardDirection.rawValue
                guardPosition = nextPosition
            }
        }

        // remove the "exited" position
        uniqueGuardPositions.remove(guardPosition)
    }
    
    // I tried to make this async but swift async does not play nice with shell executable targets 
    func findInfiniteLoops() -> Int {
        var result = 0
        // only check to add obstacles on the path the guard takes to skip some irrelevant coordinates
        for coordinate in uniqueGuardPositions {
            if simulateNewObstruction(at: coordinate) {
                result += 1
            }
        }
        return result
    }
    
    func simulateNewObstruction(at posistion: Coordinate) -> Bool {
        var map: [[String]] = initialMap
        var guardPosition = initalGuardPosition
        var guardDirection = initalGuardDirection

        map[posistion] = LabMap.OBSTACLE
        var visitedPositions: [Coordinate: Set<GuardDirection>] = [:]

        while guardPosition.row >= 0 && guardPosition.row < initialMap.count
                && guardPosition.col >= 0 && guardPosition.col < initialMap[0].count {
            let nextPosition = guardPosition.getNextGuardPosition(direction: guardDirection)
            if map[nextPosition] == LabMap.OBSTACLE {
                guardDirection = guardDirection.turn90Degrees()
                map[guardPosition] = guardDirection.rawValue
            } else {
                // if we have already visited this square while facing the same direction, we're in a loop
                if let directions = visitedPositions[nextPosition] {
                    if directions.contains(guardDirection) {
//                        print("Obstacle at (\(posistion.row), \(posistion.col)) causes infinte loop")
                        return true
                    } else {
                        visitedPositions[nextPosition, default: .init()].insert(guardDirection)
                    }
                } else {
                    visitedPositions[nextPosition, default: .init()].insert(guardDirection)
                }
                map[guardPosition] = "."
                map[nextPosition] = guardDirection.rawValue
                guardPosition = nextPosition
            }
        }
        return false
    }
    
    var description: String {
        var description = ""
        for row in initialMap {
            for col in row {
                description += col
            }
            description += "\n"
        }
        return description
    }
    
    var patrolPathMap: String {
        var description = ""
        for row in 0...initialMap.count-1 {
            for col in 0...initialMap[row].count-1 {
                if uniqueGuardPositions.contains(.init(row, col)) {
                    description += "X"
                } else {
                    description += initialMap[row][col]
                }
            }
            description += "\n"
        }
        return description
    }
}

private extension Array where Element == String {
    var guardIndex: Int? {
        self.firstIndex(where: { GuardDirection(rawValue: $0) != nil })
    }
}

private extension String {
    func findGuardDirection() -> GuardDirection? {
        for char in self {
            if let direction = GuardDirection(rawValue: String(char)) {
                return direction
            }
        }
        return nil
    }
}

private extension Coordinate {
    func getNextGuardPosition(direction: GuardDirection) -> Coordinate {
        switch direction {
        case .up:    .init(self.row-1, self.col)
        case .right: .init(self.row, self.col+1)
        case .down:  .init(self.row+1, self.col)
        case .left:  .init(self.row, self.col-1)
        }
    }
}

private extension Array where Element == [String] {
    subscript(key: Coordinate) -> String? {
        get {
            guard key.row >= 0 && key.row < self.count
                    && key.col >= 0 && key.col < self[0].count else {
                return nil
            }
            return self[key.row][key.col]
        }
        set {
            guard key.row >= 0 && key.row < self.count
                    && key.col >= 0 && key.col < self[0].count, let newValue else {
                return
            }
            self[key.row][key.col] = newValue
        }
    }
    
    var formattedDescription: String {
        var description = ""
        for row in self {
            for col in row {
                description += col
            }
            description += "\n"
        }
        return description
    }
}

guard let stringInput = getInputAsString(for: "day06") else {
    exit(1)
}

guard let labMap = LabMap(from: stringInput) else {
    exit(1)
}

print(labMap.uniqueGuardPositions.count)
print(labMap.findInfiniteLoops())
