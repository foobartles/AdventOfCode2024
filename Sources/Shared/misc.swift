//
//  misc.swift
//  AdventOfCode2024
//
//  Created by Jake Bartles on 12/8/24.
//

import Foundation


/// Returns a utf8 encoding string for the given day's text file.
/// - Parameter day: Name of day's corresponding text file, stored in Shared/Inputs directory.
/// - Returns: String of parsed text file. Nil if decoding failed or file not found.
public func getInputAsString(for day: String) -> String? {
    guard let path = Bundle.module.path(forResource: day, ofType: "txt") else {
        print("⚠️ File does not exist for \(day)")
        return nil
    }
    do {
        let stringFile = try String(contentsOfFile: path, encoding: .utf8)
        return stringFile
    } catch {
        print("⚠️ ERROR ENCODING FILE INTO STRING")
    }
    return nil
}
