//
//  BoardView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI

struct BoardView: View {
    typealias Columns = [ColumnType: [Card]]
    
    @State var columns: Columns = [:]
    @State var isTargeted: Bool = false
    
    @State private var draggingCardID: UUID?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("My kanban board")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            HStack {
                ForEach(ColumnType.allCases, id: \.self) { column in
                    ColumnView(colTitle: column.title, columnType: column, columns: $columns, draggingCardID: $draggingCardID)
                        .cornerRadius(5)
                }
            }
        }
        .padding(50)
        .background(Color.boardBackground)
    }
}

#Preview {
    BoardView(columns: [
        .todo: [Card(title: "Create new iOS project", tag: "Dev", dueDate: Date.now),
                Card(title: "Create new iOS project", tag: "Dev", dueDate: Date.now)],
        .inProgress: [Card(title: "Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Kanban web app using SwiftUI Finish Kanban web app using SwiftUI", tag: "Development", dueDate: Date.now),
                      Card(title: "Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Kanban web app using SwiftUI Finish Kanban web app using SwiftUI", tag: "Development", dueDate: Date.now),
                      Card(title: "Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Finish Kanban web app using SwiftUI Kanban web app using SwiftUI Finish Kanban web app using SwiftUI", tag: "Development", dueDate: Date.now)],
        .inReview: [Card(title: "Add", tag: "Design", dueDate: Date.now)],
        .done: [Card(title: "Add Tag color selection on Task cards", tag: "Design", dueDate: Date.now)]
    ])
}
