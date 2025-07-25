//
//  ColumnView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ColumnView: View {
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Inputs
    var colTitle: String
    let columnType: ColumnType
    @Binding var draggingCardID: UUID?
    
    @State private var cards: [Card] = []
    
    // MARK: - Local States
    @State var inputText = ""
    @State private var isTargeted = false
    @State private var selectedCard: Card? = nil
    @State private var isShowingEditForm: Bool = false
    
    var body: some View {
        
        VStack {
            // MARK: Header
            header
            
            // MARK: Cards
            cardList
            
            // MARK: Add cards session
            addCardSession
        }
        .onChange(of: draggingCardID) { _,_ in
            fetchCards()
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 30)
        .scaleEffect(isTargeted ? 1.05 : 1)
        .animation(.easeInOut, value: isTargeted)
        .background(isTargeted ? Color.colBackgroundTarget : Color.colBackground)
        .dropDestination(for: Card.self, action: { droppedCards, _ in
            handleCrossColumnDrop(droppedCards)
        }, isTargeted: { targeted in
            isTargeted = targeted
        })
        .sheet(item: $selectedCard) { card in
            CardEditFormView(editingCard: card) { updatedCard in
                // TODO: Saving logic here
            }
        }
    }
    
    private func fetchCards() {
        let descriptor = FetchDescriptor<Card>(
            predicate: #Predicate { $0.column == columnType.rawValue },
            sortBy: [SortDescriptor(\.order)]
        )
        
        do {
            cards = try modelContext.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch cards:", error)
        }
    }
    
    private func addCard() {
        guard !inputText.isEmpty else { return }
        let newCard = Card(title: inputText, column: columnType)
        newCard.order = cards.count
        modelContext.insert(newCard)
        fetchCards()
        inputText = ""
    }
    
    
    private func handleDrop(_ droppedCards: [Card], _ targetCard: Card) -> Bool {
        guard
            let droppedCard = droppedCards.first,
            droppedCard.id != targetCard.id,
            droppedCard.column == columnType.rawValue,
            targetCard.column == columnType.rawValue
        else {
            return false
        }
        
        // Get cards sorted by order (fresh snapshot)
        let sortedCards = cards.sorted { $0.order < $1.order }
        
        guard
            let sourceIndex = sortedCards.firstIndex(where: { $0.id == droppedCard.id }),
            let destinationIndex = sortedCards.firstIndex(where: { $0.id == targetCard.id })
        else {
            return false
        }
        
        // Swap positions in memory
        var swapped = sortedCards
        swapped.swapAt(sourceIndex, destinationIndex)
        
        // Reassign only the 2 involved cards
        let cardA = swapped[sourceIndex]
        let cardB = swapped[destinationIndex]
        
        return withAnimation {
            cardA.order = sourceIndex
            cardB.order = destinationIndex
            
            do {
                try modelContext.save()
                fetchCards()
                print("🔁 Swapped \(cardA.title) and \(cardB.title) at \(sourceIndex) ↔︎ \(destinationIndex)")
                draggingCardID = nil
                return true
            } catch {
                print("❌ Failed to save swap:", error)
                return false
            }
        }
    }
    
    private func handleCrossColumnDrop(_ droppedCards: [Card]) -> Bool {
        guard let droppedCard = droppedCards.first else { return false }
        
        // Avoid doing anything if it's already in the same column
        guard droppedCard.column != columnType.rawValue else { return false }
        print("📦 Dropped card into column: \(columnType)")
        
        return withAnimation {
            // 1. Update its column
            if let cardInStore = try? modelContext.fetch(FetchDescriptor<Card>()).first(where: { $0.id == droppedCard.id }) {
                print("Dropped card: \(droppedCard.id)")
                print("🔍 Found card in store: \(cardInStore.id)")
                cardInStore.column = columnType.rawValue
                cardInStore.order = cards.count
                
            } else {
                print("🔍 Card not found in store.")
            }
            
            //            droppedCard.column = columnType.rawValue
            //            droppedCard.order = cards.count
            
            do {
                try modelContext.save()
                print("✅ Saved!")
                fetchCards()
                draggingCardID = nil
                return true
            } catch {
                print("❌ Failed to save: \(error)")
                return false
            }
        }
    }
}

extension ColumnView {
    private var header: some View  {
        HStack {
            Text("\(cards.count)")
                .font(.system(size: 16))
            Text(colTitle)
                .font(.title2.bold())
            Spacer()
        }
        .foregroundColor(.black)
        .padding(.horizontal, 2)
    }
    
    private var cardList: some View {
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
                                }
                        }
                        .dropDestination(for: Card.self) { droppedCards, _ in
                            handleDrop(droppedCards, card)
                        } isTargeted: { _ in }
                        .onTapGesture {
                            selectedCard = card
                            isShowingEditForm = true
                        }
                }
            }
        }
    }
    
    private var addCardSession: some View {
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
                addCard()
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
}

struct TodoColumnView: View {
    @Binding var draggingCardID: UUID?
    
    var body: some View {
        ColumnView(colTitle: "Todo", columnType: .todo, draggingCardID: $draggingCardID)
    }
}

struct InProgressColumnView: View {
    @Binding var draggingCardID: UUID?
    
    var body: some View {
        ColumnView(colTitle: "In Progress", columnType: .inProgress, draggingCardID: $draggingCardID)
    }
}

struct InReviewColumnView: View {
    @Binding var draggingCardID: UUID?
    
    var body: some View {
        ColumnView(colTitle: "In Review", columnType: .inReview, draggingCardID: $draggingCardID)
    }
}

struct DoneColumnView: View {
    @Binding var draggingCardID: UUID?
    
    var body: some View {
        ColumnView(colTitle: "Done", columnType: .done, draggingCardID: $draggingCardID)
    }
}

#Preview {
    ColumnView(colTitle: "Todo", columnType: .todo, draggingCardID: .constant(nil))
}
