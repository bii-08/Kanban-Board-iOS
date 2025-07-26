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
    var dueDate: Date?
    var column: ColumnType.RawValue
    var order: Int
    
    var red: Double = 0.0
    var green: Double = 0.0
    var blue: Double = 0.0
    var alpha: Double = 1
    
    var tagColor: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
   
    
    init(id: UUID = UUID(), title: String, tag: String? = nil, dueDate: Date? = nil, column: ColumnType, order: Int = 0) {
        self.id = id
        self.title = title
        self.tag = tag
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
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        column = try container.decode(String.self, forKey: .column)
        order = try container.decode(Int.self, forKey: .order)
        
        red = try container.decode(Double.self, forKey: .red)
        green = try container.decode(Double.self, forKey: .green)
        blue = try container.decode(Double.self, forKey: .blue)
        alpha = try container.decode(Double.self, forKey: .alpha)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(tag, forKey: .tag)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encode(column, forKey: .column)
        try container.encode(order, forKey: .order)
        
        try container.encodeIfPresent(red, forKey: .red)
        try container.encodeIfPresent(green, forKey: .green)
        try container.encodeIfPresent(blue, forKey: .blue)
        try container.encodeIfPresent(alpha, forKey: .alpha)
    }
    
}

enum CodingKeys: String, CodingKey {
    case id, title, tag, dueDate, column, order, red, green, blue, alpha
}
extension UTType {
    nonisolated static let card = UTType(exportedAs: "com.bii.card")
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        #if canImport(AppKit)
        let nsColor = NSColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        if let rgbColor = nsColor.usingColorSpace(.deviceRGB) {
            rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            print("canImport(AppKit)")
            return (Double(red), Double(green), Double(blue), Double(alpha))
        } else {
            print("❌ Failed to convert NSColor to deviceRGB color space")
            return (0, 0, 0, 1)
        }
        
        #else
        print("can not import AppKit")
        return (0, 0, 0, 1)
        #endif
    }
}
