//
//  BellViewModel.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//
import SwiftUI

@MainActor
class BellViewModel: ObservableObject {

    @Published var selectedSchedule: ScheduleType {
        didSet {
            currentSchedule = ScheduleStorage.load(for: selectedSchedule)
        }
    }

    @Published var currentSchedule: BellSchedule {
        didSet {
            ScheduleStorage.save(currentSchedule)
            update()
        }
    }

    @Published var menuBarTitle: String = "🔔 —"
    @Published var nextBellLabel: String = "-"
    @Published var nextBellTimeText: String = "--:--"
    @Published var remainingText: String = ""

    private var timer: Timer?

    init() {
        let initialType: ScheduleType = .normal
        self.selectedSchedule = initialType
        self.currentSchedule = ScheduleStorage.load(for: initialType)

        update()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.update()
            }
        }
        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func update(now: Date = Date()) {
        let schedule = currentSchedule

        guard let (bell, interval) = BellLogic.nextBell(from: schedule, now: now) else {
            // dnes už žiadne zvonenie
            menuBarTitle = "🔔 ✓"
            nextBellLabel = "Koniec vyučovania"
            nextBellTimeText = ""
            remainingText = ""
            return
        }

        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = bell.hour
        components.minute = bell.minute
        let bellDate = calendar.date(from: components) ?? now

        let formatter = DateFormatter()
        formatter.timeStyle = .short

        nextBellLabel = bell.label
        nextBellTimeText = formatter.string(from: bellDate)

        let shortText = BellLogic.formatInterval(interval)
        remainingText = "za \(shortText)"

        menuBarTitle = "🔔 \(shortText)"
    }

    deinit {
        timer?.invalidate()
    }
}
