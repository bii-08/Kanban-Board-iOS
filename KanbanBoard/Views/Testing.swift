//
//  Testing.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/14.
//

import SwiftUI
/*
struct DraggableCard: View {
    let card: Card2

    var body: some View {
        Text(card.title)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
            .draggable(card)
    }
}

struct DropZone: View {
    @State private var dropped: Card2?
    @State private var isTargeted = false

    var body: some View {
        VStack {
            if let dropped {
                Text("Dropped: \(dropped.title)")
                    .bold()
            } else {
                Text("Drop Here")
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 200, height: 200)
        .background(isTargeted ? Color.green : Color.gray.opacity(0.2))
        .cornerRadius(12)
        .dropDestination(for: Card2.self, action: { items, _ in
            if let first = items.first {
                dropped = first
                print("✅ Dropped: \(first.title)")
                return true
            }
            print("❌ Drop failed")
            return false
        }, isTargeted: { targeted in
            isTargeted = targeted
        })
    }
}
 */
