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

        // OKNO NA ÚPRAVU ZVONENÍ
        WindowGroup("Upraviť zvonenia", id: "editor") {
            ScheduleEditorView()
                .environmentObject(viewModel)
        }
        .defaultSize(CGSize(width: 520, height: 360))

        // ABOUT OKNO
        WindowGroup("O aplikácii", id: "about") {
            AboutView()
        }
        .defaultSize(CGSize(width: 420, height: 320))
    }
}
