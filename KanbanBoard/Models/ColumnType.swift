//
//  ColumnType.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/13.
//

import Foundation

enum ColumnType: String, CaseIterable, Hashable, Codable {
    case todo
    case inProgress
    case inReview
    case done
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        guard let value = ColumnType(rawValue: raw) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ColumnType raw value: \(raw)")
        }
        self = value
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
