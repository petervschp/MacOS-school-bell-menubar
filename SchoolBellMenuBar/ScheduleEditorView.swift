//
//  ScheduleEditorView.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//

import SwiftUI

struct ScheduleEditorView: View {

    @EnvironmentObject var vm: BellViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showingImport = false
    @State private var importText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upraviť zvonenia")
                .font(.title2)

            Text(vm.currentSchedule.type.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()
                .padding(.vertical, 4)

            // ZOZNAM ZVONENÍ
            List {
                ForEach(vm.currentSchedule.bells.indices, id: \.self) { index in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {

                        // ŠÍPKY HORE / DOLE
                        VStack(spacing: 4) {
                            Button {
                                moveUp(index)
                            } label: {
                                Image(systemName: "chevron.up")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(index == 0)

                            Button {
                                moveDown(index)
                            } label: {
                                Image(systemName: "chevron.down")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(index == vm.currentSchedule.bells.count - 1)
                        }

                        // POPIS ZVONENIA
                        TextField("Popis", text: $vm.currentSchedule.bells[index].label)
                            .frame(minWidth: 150)

                        Spacer()

                        // ČAS (HOD:MIN)
                        TextField("Hod", value: $vm.currentSchedule.bells[index].hour, format: .number)
                            .frame(width: 40)
                            .multilineTextAlignment(.trailing)

                        Text(":")

                        TextField("Min", value: $vm.currentSchedule.bells[index].minute, format: .number)
                            .frame(width: 40)
                            .multilineTextAlignment(.trailing)

                        // KOŠ – ODSTRÁNIŤ ZVONENIE
                        Button {
                            deleteBell(at: index)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.red)
                    }
                    .padding(.vertical, 2)
                }
            }
            .frame(minHeight: 220)

            // TLAČIDLÁ DOLE
            HStack {
                Button("Pridať zvonenie") {
                    let new = BellTime(hour: 8, minute: 0, label: "Nové zvonenie")
                    vm.currentSchedule.bells.append(new)
                }

                Button("Importovať zoznam…") {
                    importText = ""
                    showingImport = true
                }

                Spacer()

                Button("Zavrieť") {
                    normalizeSchedule()
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(16)
        .frame(minWidth: 520, minHeight: 340)
        .sheet(isPresented: $showingImport) {
            importSheet
        }
    }

    // MARK: - Pohyb hore/dolu

    private func moveUp(_ index: Int) {
        guard index > 0 else { return }
        vm.currentSchedule.bells.swapAt(index, index - 1)
    }

    private func moveDown(_ index: Int) {
        guard index < vm.currentSchedule.bells.count - 1 else { return }
        vm.currentSchedule.bells.swapAt(index, index + 1)
    }

    private func deleteBell(at index: Int) {
        guard vm.currentSchedule.bells.indices.contains(index) else { return }
        vm.currentSchedule.bells.remove(at: index)
    }

    /// Usporiada zvonenia podľa času (hod, min) vzostupne.
    private func normalizeSchedule() {
        vm.currentSchedule.bells.sort { a, b in
            if a.hour == b.hour {
                return a.minute < b.minute
            } else {
                return a.hour < b.hour
            }
        }
    }

    // MARK: - Import

    private var importSheet: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Importovať zoznam zvonení")
                .font(.title3)

            Text("""
            Formát pre každý riadok:
            HH:MM;Popis zvonenia

            Príklad:
            7:45;Začiatok 1. hodiny
            8:30;Koniec 1. hodiny
            8:35;Začiatok 2. hodiny
            """)
            .font(.footnote)
            .foregroundStyle(.secondary)

            TextEditor(text: $importText)
                .font(.system(.body, design: .monospaced))
                .border(Color.secondary.opacity(0.4))
                .frame(minHeight: 180)

            HStack {
                Spacer()
                Button("Zrušiť") {
                    showingImport = false
                }

                Button("Importovať") {
                    applyImport()
                    showingImport = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(16)
        .frame(width: 520, height: 360)
    }

    private func applyImport() {
        let lines = importText
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var newBells: [BellTime] = []

        for line in lines {
            // Očakávame "HH:MM;Popis"
            let parts = line.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: true)
            guard let timePartSub = parts.first else { continue }
            let timePart = timePartSub.trimmingCharacters(in: .whitespaces)

            let label: String
            if parts.count > 1 {
                label = parts[1].trimmingCharacters(in: .whitespaces)
            } else {
                label = "Zvonenie"
            }

            let timePieces = timePart.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
            guard timePieces.count == 2,
                  let hour = Int(timePieces[0].trimmingCharacters(in: .whitespaces)),
                  let minute = Int(timePieces[1].trimmingCharacters(in: .whitespaces)) else {
                continue
            }

            newBells.append(BellTime(hour: hour, minute: minute, label: label))
        }

        if !newBells.isEmpty {
            vm.currentSchedule.bells = newBells
            normalizeSchedule()
        }
    }
}
