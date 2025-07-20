//
//  ColumnType.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/13.
//

import Foundation

enum ColumnType: String, CaseIterable, Hashable {
    case todo
    case inProgress
    case inReview
    case done
    
    var title: String {
           switch self {
           case .todo: return "To Do"
           case .inProgress: return "In Progress"
           case .inReview: return "In Review"
           case .done: return "Done"
           }
       }
}
