//
//  AboutView.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//

import SwiftUI

struct AboutView: View {

    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "SchoolBellMenuBar"
    }

    private var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
        return "Version \(version) (build \(build))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Názov + verzia
            VStack(alignment: .leading, spacing: 4) {
                Text(appName)
                    .font(.title)
                    .bold()

                Text(appVersion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .padding(.vertical, 4)

            // Stručný popis
            Text("""
            Školský zvonček v lište macOS, ktorý ukazuje zostávajúci čas \
            do najbližšieho zvonenia a umožňuje upravovať rozvrhy zvonení.
            """)
            .font(.body)

            // Disclaimer – skrátená verzia
            VStack(alignment: .leading, spacing: 4) {
                Text("Upozornenie")
                    .font(.headline)

                Text("""
                Aplikácia je určená na informačné a vzdelávacie účely. \
                Nesmie sa používať ako bezpečnostne kritický systém \
                (napr. jediný zdroj zvonenia pri evakuácii alebo požiarnom poplachu). \
                Používaš ju na vlastné riziko; autor nenesie zodpovednosť \
                za škody spôsobené jej použitím alebo zneužitím.
                """)
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            // Voliteľne link na GitHub (ak nechceš, tento blok vyhoď)
            if let url = URL(string: "https://github.com/petervschp/MacOS-school-bell-menubar") {
                HStack {
                    Spacer()
                    Link("Projekt na GitHube", destination: url)
                        .font(.footnote)
                }
            }
        }
        .padding(20)
        .frame(minWidth: 420, minHeight: 260, alignment: .topLeading)
    }
}
