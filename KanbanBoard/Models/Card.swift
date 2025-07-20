//
//  Card.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

nonisolated struct Card: Codable, Identifiable, Hashable, Transferable, Sendable {
    
    var id: UUID
    var title: String
    var tag: String?
    var tagColor: String? = "#10b981"
    var dueDate: Date?
    
    init(id: UUID = UUID(), title: String, tag: String? = nil, tagColor: String? = "#10b981", dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.tag = tag
        self.tagColor = tagColor
        self.dueDate = dueDate
    }
   static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }

}

extension UTType {
    nonisolated static let card = UTType(exportedAs: "com.bii.card")

}

nonisolated struct Card2: Codable, Identifiable, Hashable, Transferable, Sendable {
    let id: UUID
    let title: String

        init(title: String) {
            self.id = UUID()
            self.title = title
        }

     static var transferRepresentation: some TransferRepresentation {
            CodableRepresentation(contentType: .card2)
        }
}

extension UTType {
    nonisolated static let card2 = UTType(exportedAs: "com.bii.card2")
}


