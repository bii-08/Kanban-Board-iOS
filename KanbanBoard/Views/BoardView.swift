//
//  BoardView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI
import SwiftData

struct BoardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var draggingCardID: UUID?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("My kanban board")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            HStack {
                TodoColumnView(draggingCardID: $draggingCardID)
                    .cornerRadius(5)
                InProgressColumnView(draggingCardID: $draggingCardID)
                    .cornerRadius(5)
                InReviewColumnView(draggingCardID: $draggingCardID)
                    .cornerRadius(5)
                DoneColumnView(draggingCardID: $draggingCardID)
                    .cornerRadius(5)
            }
        }
        .onAppear {
            // MARK: Testing
            //deleteAllCards()
        }
        .padding(50)
        .background(Color.boardBackground)
    }
    
    private func deleteAllCards() {
        let descriptor = FetchDescriptor<Card>()
        do {
            let allCards = try modelContext.fetch(descriptor)
            for card in allCards {
                modelContext.delete(card)
            }
            try modelContext.save()
            print("🗑️ All cards deleted on launch")
        } catch {
            print("❌ Failed to delete all cards:", error)
        }
    }
}

#Preview {
    BoardView()
}
