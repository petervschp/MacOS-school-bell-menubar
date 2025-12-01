//
//  ContentView.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//

import SwiftUI
import AppKit   // kvôli NSApplication.shared.terminate

struct ContentView: View {

    @EnvironmentObject var vm: BellViewModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // HLAVIČKA
            VStack(alignment: .leading, spacing: 2) {
                Text("Školské zvonenie")
                    .font(.headline)

                Text(vm.selectedSchedule.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .padding(.vertical, 4)

            // NAJBLIŽŠIE ZVONENIE
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.nextBellLabel)
                    .font(.title3)

                HStack {
                    Text(vm.nextBellTimeText)
                        .font(.title2)
                    Spacer()
                    Text(vm.remainingText)
                        .font(.body)
                }
            }

            Divider()
                .padding(.vertical, 4)

            // VÝBER ROZVRHU
            VStack(alignment: .leading, spacing: 4) {
                Text("Režim rozvrhu:")
                    .font(.subheadline)

                Picker("Režim rozvrhu", selection: $vm.selectedSchedule) {
                    ForEach(ScheduleType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(RadioGroupPickerStyle())
            }

            Divider()
                .padding(.vertical, 4)

            // TLAČIDLÁ DOLE
            HStack {
                Button("Upraviť zvonenia…") {
                    openWindow(id: "editor")
                }

                Button("O aplikácii…") {
                    openWindow(id: "about")
                }

                Spacer()

                Button("Ukončiť") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .padding(16)
        .frame(minWidth: 360, alignment: .leading)
    }
}
