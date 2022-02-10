//
//  Target.swift
//  NewSmartSteps
//
//  Created by Sergey Ivanov on 26/06/2018.
//  Copyright © 2018 Sergey Ivanov. All rights reserved.
//
import UIKit
import Foundation

class Target: Codable {
    var name: String
    var description: String
    var steps: [Step]
    
    static var archiveURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("Targets").appendingPathExtension("plist")
        return archiveURL
    }
    
    init(name: String, description: String, startDate: Date, endDate: Date, interval: Int) {
        self.name = name
        self.description = description
        
        let calendar = Calendar.current
        var steps: [Step] = []
        
        if startDate.compare(endDate)  == .orderedAscending {
            
            var addingDate = startDate
            
            repeat {
                let step = Step(date: addingDate)
                steps.append(step)
                addingDate = calendar.date(byAdding: .day, value: interval, to: addingDate)!
            } while addingDate.compare(endDate)  == .orderedAscending
            
        } else { steps = [] }
        
        self.steps = steps
    }
    
    //Mark: - Write and Load to file methods
    
    static func saveToFile(targets: [Target]) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedTargets = try? propertyListEncoder.encode(targets), ((try? encodedTargets.write(to: Target.archiveURL)) != nil) {
            print("\n [\(Date())] save to file done!")
        }
        
    }
    
    static func loadFromFile() -> [Target] {
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedData = try? Data(contentsOf: Target.archiveURL), let decodedTargets = try? propertyListDecoder.decode(Array<Target>.self, from: retrievedData) {
            print("\n [\(Date())] data is loaded.")
            return decodedTargets
        } else {
            print("\n [\(Date())] data is not loaded, used example array.")
            return Target.targetExample()
        }
        
    }
    
    /*
    //MARK: - Automate fill not marked steps
    
    static func fillNotMarkedSteps(in targets: [Target]) {
        let calendar = Calendar.current
        for target in targets {
            for step in target.steps {
                let date = step.date
                
                if (date.compare(Date())  == .orderedAscending) && !(calendar.isDateInToday(date)) {
                    if step.mark == .notSet {
                        step.description = "Шаг пропущен."
                        step.mark = .missed
                    }
                
                }
            }
        }
    }
    */
    
    //MARK: - return array with today steps indexes
    
    static func todayStepsIndexArray(in targets: [Target]) -> [Int] {
        guard !targets.isEmpty else { return []}
        let calendar = Calendar.current
        var indexArray: [Int] = []
        for index in 0...targets.count-1 {
            let target = targets[index]
            for step in target.steps {
                if calendar.isDateInToday(step.date) && step.mark == .notSet {
                    indexArray.append(index)
                }
            }
        }
        return indexArray
    }
    
    static func targetExample() -> [Target] {
        let calendar = Calendar.current
        let date1 = calendar.date(byAdding: .day, value: 1, to: Date())!
        let date2 = calendar.date(byAdding: .day, value: 5, to: date1)!
        return [Target(name: "Файл с целями не обнаружен", description: "обратитесь в техподдержку", startDate: date1, endDate: date2, interval: 1)]
    }
    
    class Step: Codable {
        var date: Date
        var description: String
        var mark: Mark
        
        var notificationMorningId: String
        var notificationEveningId: String
        
        init(date: Date) {
            self.date = date
            self.description = ""
            mark = .notSet
            notificationMorningId = UUID().uuidString
            notificationEveningId = UUID().uuidString
        }
    }
    
    enum Mark: String, Codable {
        case notSet = "notSet"
        case done = "done"
        case notDone = "notDone"
        
    }
    
    

}









