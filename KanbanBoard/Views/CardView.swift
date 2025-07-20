//
//  CardView.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI

struct CardView: View {
    
    var card: Card
    @State private var isHovering = false
    var isDragging: Bool?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if let tag = card.tag {
                Text("#\(tag)")
                    .padding(3)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            
            Text(card.title)
                .font(.title3)
                .foregroundColor(.black)
            if (card.dueDate != nil) {
                HStack {
                    Text("⏰")
                    Text(card.dueDate ?? Date(), style: .date)
                        .cornerRadius(20)
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                }
                .padding(3)
                .background(Color.yellow)
                .cornerRadius(5)
            }
        }
        .frame(maxWidth: 300, alignment: .leading)
        .padding(15)
        .padding(.leading, 8)
        .overlay(
            isHovering ?
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 2)
                .opacity(0.8)
            : nil
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .background(isDragging ?? false ? Color.cardDraggingBackground : Color.white)
        .border(isDragging ?? false ? Color.black : Color.clear)
        .cornerRadius(5)
        
        
    }
}

#Preview {
    CardView(card: Card(title: "Create new iOS project",tag: "Development", dueDate: Date()))
    
}
