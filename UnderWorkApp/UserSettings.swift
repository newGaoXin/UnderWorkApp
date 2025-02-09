//
//  UserSettings.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/2.
//
import Foundation

class UserSettings: ObservableObject {
    @Published var monthlySalary: Double = 0.0
    @Published var workStartTime = Date()
    @Published var workEndTime = Date()
    @Published var restType: RestType = .doubleRest
    @Published var customRestDays: Set<Weekday> = []
    
    static let shared = UserSettings()
    
    private init() {
        loadFromUserDefaults()
    }
    
    func saveToUserDefaults() {
        UserDefaults.standard.set(monthlySalary, forKey: "monthlySalary")
        UserDefaults.standard.set(workStartTime, forKey: "workStartTime")
        UserDefaults.standard.set(workEndTime, forKey: "workEndTime")
        UserDefaults.standard.set(restType.rawValue, forKey: "restType")
        let restDaysArray = Array(customRestDays.map { $0.rawValue })
        UserDefaults.standard.set(restDaysArray, forKey: "customRestDays")
    }
    
    private func loadFromUserDefaults() {
        monthlySalary = UserDefaults.standard.double(forKey: "monthlySalary")
        workStartTime = UserDefaults.standard.object(forKey: "workStartTime") as? Date ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        workEndTime = UserDefaults.standard.object(forKey: "workEndTime") as? Date ?? Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        restType = RestType(rawValue: UserDefaults.standard.integer(forKey: "restType")) ?? .doubleRest
          let restDaysArray = UserDefaults.standard.array(forKey: "customRestDays") as? [Int] ?? []
          customRestDays = Set(restDaysArray.compactMap { Weekday(rawValue: $0) })
    }
    
    enum RestType: Int {
           case doubleRest   // 双休
           case singleRest   // 单休
           case custom       // 自定义
       }
    
    enum Weekday: Int, CaseIterable {
           case mon = 1, tue, wed, thu, fri, sat, sun
       }
    
    // 在UserSettings中添加
    var workHoursPerDay: Double {
        Double(Calendar.current.dateComponents([.hour, .minute], from: workStartTime, to: workEndTime).hour ?? 8)
    }

    var workDaysPerMonth: Double {
        switch restType {
        case .doubleRest: return 22
        case .singleRest: return 26
        case .custom: return Double(7 - customRestDays.count) * 4.3
        }
    }
}
