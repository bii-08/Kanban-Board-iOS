//
//  Card.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import SwiftData

@Model
nonisolated
final class Card: Codable, Identifiable, Hashable, Transferable, Sendable {
    
    var id: UUID
    var title: String
    var tag: String?
    var tagColor: String? = "#10b981"
    var dueDate: Date?
    var column: ColumnType.RawValue
    var order: Int
   
    
    init(id: UUID = UUID(), title: String, tag: String? = nil, tagColor: String? = "#10b981", dueDate: Date? = nil, column: ColumnType, order: Int = 0) {
        self.id = id
        self.title = title
        self.tag = tag
        self.tagColor = tagColor
        self.dueDate = dueDate
        self.column = column.rawValue
        self.order = order
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        tag = try container.decodeIfPresent(String.self, forKey: .tag)
        tagColor = try container.decodeIfPresent(String.self, forKey: .tagColor)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        column = try container.decode(String.self, forKey: .column)
        order = try container.decode(Int.self, forKey: .order)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(tag, forKey: .tag)
        try container.encodeIfPresent(tagColor, forKey: .tagColor)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encode(column, forKey: .column)
        try container.encode(order, forKey: .order)
    }
    
}

enum CodingKeys: String, CodingKey {
    case id, title, tag, tagColor, dueDate, column, order
}
extension UTType {
    nonisolated static let card = UTType(exportedAs: "com.bii.card")
}
