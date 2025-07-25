//
//  KanbanBoardApp.swift
//  KanbanBoard
//
//  Created by LUU THANH TAM on 2025/07/11.
//

import SwiftUI
import SwiftData

@main
struct KanbanBoardApp: App {
    let container: ModelContainer
    
    init() {
        do {
            
            container = try ModelContainer(for: Card.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
        
        // print the SQL file's path (SwiftData)
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            BoardView()
        }
        .modelContainer(container)
    }
}
