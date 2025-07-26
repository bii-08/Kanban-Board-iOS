//
//  CardEditFormView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/15.
//

import SwiftUI
import SwiftData

struct CardEditFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let originalCard: Card
    @State var title: String
    @State var tag: String?
    @State var dueDate: Date?
    let onSave: (String, String?, Date?, Color) -> Void
    
    @State private var showColorPicker = false
    @State private var selectedColor: Color = .blue
    
    init(originalCard: Card, onSave: @escaping (String, String?, Date?, Color) -> Void) {
        self.originalCard = originalCard
        _title = State(initialValue: originalCard.title)
        _tag = State(initialValue: originalCard.tag ?? "")
        _dueDate = State(initialValue: originalCard.dueDate)
        _selectedColor = State(initialValue: originalCard.red != 0.0 && originalCard.green != 0.0 && originalCard.blue != 0.0 ? Color(red: originalCard.red, green: originalCard.green, blue: originalCard.blue) : .blue)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Tag", text: Binding(
                        get: { tag ?? "" },
                        set: { tag = $0.isEmpty ? nil : $0 }
                    ))
                    
                    ColorPicker("Tag color", selection: $selectedColor)
                    
                    DatePicker("Due Date", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: [.date])
                }
            }
            .padding(10)
            .navigationTitle("Edit Card")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if hasChanged() {
                            onSave(title, tag, dueDate, selectedColor)
                        }
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
    
    private func hasChanged() -> Bool {
        
        if originalCard.title != title || originalCard.dueDate != dueDate || originalCard.tagColor != selectedColor ||
            originalCard.tag != tag {
            return true
        }
        return false
    }
}

#Preview {
    CardEditFormView(originalCard: Card(id: UUID(), title: "Test", dueDate: Date(), column: ColumnType.todo), onSave: { _,_,_,_ in })
}
