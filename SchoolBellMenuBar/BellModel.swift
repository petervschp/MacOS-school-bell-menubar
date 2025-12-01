//
//  BellModel.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//
import Foundation

// Jeden čas zvonenia (napr. "Začiatok 1. hodiny o 7:45")
struct BellTime: Identifiable, Codable, Hashable {
    var id = UUID()
    var hour: Int
    var minute: Int
    var label: String
}

// Typ rozvrhu (normálne, skrátené, iná škola)
enum ScheduleType: String, CaseIterable, Identifiable, Codable {
    case normal = "Normálne vyučovanie"
    case shortened = "Skrátené vyučovanie"
    case otherSchool = "Iná škola"

    var id: Self { self }
}

// Jeden rozvrh (typ + zoznam zvonení)
struct BellSchedule: Codable, Hashable {
    var type: ScheduleType
    var bells: [BellTime]
}

// Predvolené rozvrhy – môžeš si ich neskôr upraviť
struct DefaultSchedules {

    static func `for`(_ type: ScheduleType) -> BellSchedule {
        switch type {
        case .normal:
            return BellSchedule(
                type: .normal,
                bells: [
                    BellTime(hour: 7, minute: 45, label: "Začiatok 1. hodiny"),
                    BellTime(hour: 8, minute: 30, label: "Koniec 1. hodiny"),
                    BellTime(hour: 8, minute: 35, label: "Začiatok 2. hodiny"),
                    BellTime(hour: 9, minute: 20, label: "Koniec 2. hodiny"),
                    BellTime(hour: 9, minute: 35, label: "Začiatok 3. hodiny"),
                    BellTime(hour: 10, minute: 20, label: "Koniec 3. hodiny")
                ]
            )

        case .shortened:
            return BellSchedule(
                type: .shortened,
                bells: [
                    BellTime(hour: 7, minute: 45, label: "Začiatok 1. skr. hodiny"),
                    BellTime(hour: 8, minute: 20, label: "Koniec 1. skr. hodiny"),
                    BellTime(hour: 8, minute: 25, label: "Začiatok 2. skr. hodiny"),
                    BellTime(hour: 9, minute: 0, label: "Koniec 2. skr. hodiny")
                ]
            )

        case .otherSchool:
            return BellSchedule(
                type: .otherSchool,
                bells: [
                    BellTime(hour: 8, minute: 0, label: "Začiatok 1. hodiny (iná škola)")
                ]
            )
        }
    }
}

// Čistá logika výpočtu
struct BellLogic {

    /// Nájde najbližšie zvonenie po "now" a vráti (BellTime, interval v sekundách).
    static func nextBell(from schedule: BellSchedule, now: Date = Date()) -> (BellTime, TimeInterval)? {
        let calendar = Calendar.current
        let today = now

        let bellDates: [(BellTime, Date)] = schedule.bells.compactMap { bell in
            var components = calendar.dateComponents([.year, .month, .day], from: today)
            components.hour = bell.hour
            components.minute = bell.minute
            components.second = 0

            guard let date = calendar.date(from: components) else { return nil }
            return (bell, date)
        }

        let futureBells = bellDates.filter { $0.1 > now }
        guard let (nextBell, nextDate) = futureBells.sorted(by: { $0.1 < $1.1 }).first else {
            return nil
        }

        let interval = nextDate.timeIntervalSince(now)
        return (nextBell, interval)
    }

    /// Vráti text v štýle "XmYYs", napr. "3m07s"
    static func formatInterval(_ interval: TimeInterval) -> String {
        let totalSeconds = max(0, Int(interval))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%dm%02ds", minutes, seconds)
    }
}
