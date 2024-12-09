//
//  extensions.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

public extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
