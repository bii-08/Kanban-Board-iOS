//
//  ColumnView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI
import UniformTypeIdentifiers

struct ColumnView: View {
    
    var colTitle: String
    @State var inputText = ""
    
    let columnType: ColumnType
    @Binding var columns: [ColumnType: [Card]]
    @State private var isTargeted = false
    var cards: [Card] {
        columns[columnType] ?? []
    }
    
    @State private var selectedCard: Card? = nil
    @State private var isShowingEditForm: Bool = false
    
    @Binding var draggingCardID: UUID?
    
    var isSourceCol: Bool {
        guard let id = draggingCardID else {
            return false
        }
        return cards.contains(where: { $0.id == id })
    }
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("\(cards.count)")
                    .font(.system(size: 16))
                Text(colTitle)
                    .font(.title2.bold())
                Spacer()
            }
            .foregroundColor(.black)
            .padding(.horizontal, 2)
            
            ScrollView {
                LazyVStack(alignment: .center) {
                    ForEach(cards) { card in
                        CardView(card: card)
                            .draggable(card) {
                                CardView(card: card, isDragging: true)
                                    .contentShape(Rectangle())
                                    .padding(15)
                                    .rotationEffect(.degrees(-5))
                                    .onAppear {
                                        draggingCardID = card.id
                                        print("🌈 draggingCardID set: \(draggingCardID?.uuidString ?? "-")")
                                    }
                            }
                            .dropDestination(for: Card.self) { droppedCards, _ in
                                guard
                                    let droppedCard = droppedCards.first,
                                    droppedCard.id != card.id,
                                    let sourceIndex = columns[columnType]?.firstIndex(where: { $0.id == droppedCard.id }),
                                    let destinationIndex = columns[columnType]?.firstIndex(where: { $0.id == card.id })
                                else {
                                    return false
                                }
                                
                                // Simple swap logic
                                withAnimation {
                                    var cards = columns[columnType]!
                                    cards.swapAt(sourceIndex, destinationIndex)
                                    columns[columnType] = cards
                                    print("🔁 Swapped index \(sourceIndex) ↔︎ \(destinationIndex)")
                                }
                                
                                draggingCardID = nil
                                return true
                            } isTargeted: { _ in }
                            .onTapGesture {
                                selectedCard = card
                                print("This is tapped card: \(selectedCard?.title ?? "No selected card was found at tapping")")
                                isShowingEditForm = true
                            }
                    }
                }
            }
            
            HStack(alignment: .center) {
                ZStack(alignment: .leading) {
                    if inputText.isEmpty {
                        Text("Add a card...")
                            .foregroundStyle(Color.black)
                    }
                    
                    TextField("", text: $inputText)
                        .foregroundStyle(Color.black)
                        .textFieldStyle(.plain)
                }
                .padding(.leading, 10)
                .frame(maxWidth: .infinity, minHeight: 34)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                
                Button {
                    //TODO: Add card logic
                    addCard(cardTitle: inputText)
                    
                } label: {
                    Text("➕")
                        .frame(maxWidth: 34, maxHeight: 34)
                        .background(Color.colAddCardBtn)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 25)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 30)
        .scaleEffect(isTargeted ? 1.05 : 1)
        .animation(.easeInOut, value: isTargeted)
        .background(isTargeted ? Color.colBackgroundTarget : Color.colBackground)
        .dropDestination(for: Card.self, action: { droppedCards, _ in
            guard let droppedCard = droppedCards.first else { return false }
            print("📦 Cross-column drop to \(columnType)")
            // Remove from source
            for key in columns.keys {
                if let index = columns[key]?.firstIndex(where: { $0.id == droppedCard.id }) {
                    columns[key]?.remove(at: index)
                    break
                }
            }
            
            // Add to bottom
            withAnimation {
                columns[columnType, default: []].append(droppedCard)
            }
            draggingCardID = nil
            return true
            
        }, isTargeted: { targeted in
            isTargeted = targeted
        })
        .sheet(item: $selectedCard) { card in
            CardEditFormView(editingCard: card) { updatedCard in
                // TODO: Saving logic here
                for key in columns.keys {
                    if let index = columns[key]?.firstIndex(where: { $0.id == updatedCard.id }) {
                        columns[key]?[index] = updatedCard
                        print("✅ Updated card in column \(key): \(updatedCard.title)")
                        break
                    }
                }
            }
        }
    }
    
    
    private func addCard(cardTitle: String) {
        let newCard = Card(title: cardTitle)
        columns[columnType, default: []].append(newCard)
        inputText = ""
    }
    
}

#Preview {
    ColumnView(colTitle: "Todo",
               columnType: .todo,
               columns: Binding.constant([.todo: [], .inProgress: [], .inReview: [], .done: []]), draggingCardID: Binding.constant(nil)
    )
}
