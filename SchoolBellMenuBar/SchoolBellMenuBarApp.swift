//
//  SchoolBellMenuBarApp.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//

import SwiftUI

@main
struct SchoolBellMenuBarApp: App {

    @StateObject private var viewModel = BellViewModel()

    var body: some Scene {
        // MENU BAR APP
        MenuBarExtra(viewModel.menuBarTitle) {
            ContentView()
                .environmentObject(viewModel)
        }
        .menuBarExtraStyle(.window)

        // SAMOSTATNÉ OKNO NA UPRAVU ZVONENÍ
        WindowGroup("Upraviť zvonenia", id: "editor") {
            ScheduleEditorView()
                .environmentObject(viewModel)
        }
        .defaultSize(CGSize(width: 520, height: 360))
    }
}
