//
//  CardEditFormView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/15.
//

import SwiftUI

struct CardEditFormView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var editingCard: Card
    let onSave: (Card) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $editingCard.title)
                    TextField("Tag", text: Binding(
                        get: { editingCard.tag ?? "" },
                        set: { editingCard.tag = $0.isEmpty ? nil : $0 }
                    ))
                    DatePicker("Due Date", selection: Binding(
                        get: { editingCard.dueDate ?? Date() },
                        set: { editingCard.dueDate = $0 }
                    ), displayedComponents: [.date])
                }
            }
            .padding(10)
            .navigationTitle("Edit Card")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(editingCard)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CardEditFormView(editingCard: Card(id: UUID(), title: "Test", dueDate: Date(), column: ColumnType.todo), onSave: { _ in })
}
