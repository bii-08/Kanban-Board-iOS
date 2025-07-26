//
//  SwiftUIView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/26.
//

import SwiftUI
import SwiftData

struct TrashAreaView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var cards: [Card]
    @State private var isTargeted = false
   
    var body: some View {
        VStack {
            Image(systemName: "trash")
                .imageScale(.large)
        }
        .frame(maxWidth: 100, maxHeight: 100, alignment: .center)
        .background(isTargeted ? Color.red : Color.gray.opacity(0.9))
        .dropDestination(for: Card.self, action: { droppedCards, _ in
            handleDeleteWhenDropped(droppedCards)
        }, isTargeted: { targeted in
           isTargeted = targeted
        })
    }
    
    private func handleDeleteWhenDropped(_ droppedCards: [Card]) -> Bool {
        guard let droppedCard = droppedCards.first else { return false }
        if let cardInStore = cards.first(where: { $0.id == droppedCard.id }) {
            withAnimation {
                modelContext.delete(cardInStore)
            }
            do {
                try modelContext.save()
                return true
            } catch {
                print("Error saving after delete: \(error)")
                return false
            }
        } else {
            print("Card not found in store")
            return false
        }
    }
}

#Preview {
    TrashAreaView()
}
