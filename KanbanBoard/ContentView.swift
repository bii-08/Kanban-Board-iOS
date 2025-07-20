//
//  ContentView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var droppedText: String?
    var body: some View {
        HStack(spacing: 60) {
            DraggableCard(card: Card2(title: "This is a task"))
            DropZone()
        }
        .padding(40)
//        HStack(spacing: 40) {
//                    Text("🟦 Drag me")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                        .draggable("This is dragged text") // ← Using a raw String
//
//                    VStack {
//                        if let droppedText {
//                            Text("Dropped: \(droppedText)")
//                                .bold()
//                        } else {
//                            Text("Drop Here")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .frame(width: 200, height: 200)
//                    .background(Color.green.opacity(0.2))
//                    .cornerRadius(12)
//                    .dropDestination(for: String.self, action: { items, _ in
//                        print("✅ Dropped item: \(items.first ?? "<empty>")")
//                        droppedText = items.first
//                        return true
//                    }, isTargeted: { targeted in
//                        print("🎯 Is targeted: \(targeted)")
//                    })
//                }
//                .padding(40)
    }

}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
