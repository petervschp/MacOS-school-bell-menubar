//
//  ScheduleStorage.swift
//  SchoolBellMenuBar
//
//  Created by Peter Valachovič on 01/12/2025.
//

import Foundation

struct ScheduleStorage {

    private static func key(for type: ScheduleType) -> String {
        "bellSchedule_\(type.rawValue)"
    }

    /// Načíta rozvrh z UserDefaults alebo vráti predvolený
    static func load(for type: ScheduleType) -> BellSchedule {
        let defaults = UserDefaults.standard
        let key = key(for: type)

        if let data = defaults.data(forKey: key),
           let schedule = try? JSONDecoder().decode(BellSchedule.self, from: data) {
            return schedule
        } else {
            return DefaultSchedules.for(type)
        }
    }

    /// Uloží rozvrh do UserDefaults
    static func save(_ schedule: BellSchedule) {
        let defaults = UserDefaults.standard
        let key = key(for: schedule.type)

        if let data = try? JSONEncoder().encode(schedule) {
            defaults.set(data, forKey: key)
        }
    }
}
