//
//  PowerUpModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/21/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation

class PowerUpLevel{
    var displayValue: String = ""
    var levelNumber: Int = 0
    var displayText: String
    
    var value: Int
    var secondaryValue: Int
    
    init(levelNumber:Int, displayText: String, value: Int = 0, secondaryValue: Int = 0){
        self.levelNumber = levelNumber
        self.displayText = displayText
        self.secondaryValue = secondaryValue
        self.value = value
    }
}


class PowerUp{
    
    var name: String = ""
    var discription: String = ""
    var shortCode: String = ""
    var type: PowerUpType = .xray
    var levels: [Int:PowerUpLevel] = [:]
    var secondaryLevels: [Int:PowerUpLevel] = [:]
    
    var currentLevel: Int = 0
    var currentSecondaryLevel: Int = 0
    var remainingPass: Int = 2
    
    var remainingFunctios: Int = 0
    var powerUpUsed: Bool = false
    
    func resetRemainings(){
        switch type{
        case .xray:
            self.remainingFunctios = 0
            break
        case .crazySweeper:
            self.remainingFunctios = self.getCurrentLevelSecondaryValue() * 100
            break
        case .protector:
            self.remainingFunctios = self.getCurrentLevelValue()
            break
        case .none:
            break
        }
    }
    
    init(powerUpType: PowerUpType){
        self.type = powerUpType
        switch(powerUpType){
        case .xray:
            self.name = "Mines X-Ray"
            self.shortCode = "xray"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "", value: 0, secondaryValue: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "Lv.1", value: 1, secondaryValue: 3)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "Lv.2", value: 2, secondaryValue: 3)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "Lv.3", value: 3, secondaryValue: 3)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "Lv.4", value: 5, secondaryValue: 3)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "Lv.5", value: 5, secondaryValue: 5)
            break
        case .crazySweeper:
            self.name = "Crazy Sweeper"
            self.shortCode = "sweeper"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "", value: 0, secondaryValue: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "Lv.1", value: 5, secondaryValue: 5)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "Lv.2", value: 8, secondaryValue: 13)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "Lv.3", value: 10, secondaryValue: 17)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "Lv.4", value: 12, secondaryValue: 20)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "Lv.5", value: 100, secondaryValue: 100)
            
            self.secondaryLevels[0] = PowerUpLevel(levelNumber:0, displayText: "", value: 1)
            self.secondaryLevels[1] = PowerUpLevel(levelNumber:1, displayText: "Lv.1", value: 2)
            self.secondaryLevels[2] = PowerUpLevel(levelNumber:2, displayText: "Lv.2", value: 3)
            self.secondaryLevels[3] = PowerUpLevel(levelNumber:3, displayText: "Lv.3", value: 4)
            self.secondaryLevels[4] = PowerUpLevel(levelNumber:4, displayText: "Lv.4", value: 5)
            self.secondaryLevels[5] = PowerUpLevel(levelNumber:5, displayText: "Lv.5", value: 6)
            
            break
        case .protector:
            self.name = "Mine Protector"
            self.shortCode = "protector"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "", value: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "x1", value: 1)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "x2", value: 2)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "x3", value: 3)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "x4", value: 4)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "x5", value: 5)
            break
            
        case .none:
            break
        }
    }
    
    func getCurrentLevel() -> PowerUpLevel{
        if let lv = self.levels[self.currentLevel]{
            return lv
        }   else    {
            return self.levels[0]!
        }
    }
    
    func getCurrentSecondaryLevel() -> PowerUpLevel{
        if let lv = self.secondaryLevels[self.currentSecondaryLevel]{
            return lv
        }   else    {
            return self.secondaryLevels[0]!
        }
    }
    
    func getCurrentLevelValue() -> Int{
        return self.getCurrentLevel().value
    }
    func getCurrentLevelSecondaryValue() -> Int{
        return self.getCurrentSecondaryLevel().value
    }
    func getDescription() -> String{
        
        if self.currentLevel == 0 {
            return "Please unlock this powerup first"
        }
        
        switch self.type {
        case .xray:
            return "Detect any mine within \(self.levels[self.currentLevel]!.displayText) Range"
        case .crazySweeper:
            var rangeText = "anywhere inside a " + self.levels[self.currentLevel]!.displayText + " block"
            if self.currentLevel == 5 {
                rangeText = "anywhere"
            }
            return "Click \(rangeText) within \(self.secondaryLevels[self.currentSecondaryLevel]!.displayText)"
        case .protector:
            return "Correct your first \(self.levels[self.currentLevel]!.value) wrong Sweepes"
        
        case .none:
            return ""
        }
    }
    func getStoreUpgradeText() -> String{
        if self.currentLevel == 0 {
            return "Unlock \(self.name)"
        }   else if self.currentLevel < 5{
            return "Upgrade to \(self.name) \(self.levels[currentLevel + 1]!.displayText)"
        }   else{
            return "Fully Upgraded"
        }
    }
    func getStoreSecondaryUpgradeText() -> String{
        if self.currentSecondaryLevel == 0 {
            return "Unlock \(self.name)"
        }   else if self.currentSecondaryLevel < 5{
            return "Upgrade to \(self.name) \(self.secondaryLevels[currentLevel + 1]!.displayText)"
        }   else{
            return "Fully Upgraded"
        }
    }
    func loadFromStorage(){
        
    }
    func exportRecordObject() -> [String: Int]{
        let powerUpRecord : [String: Int] = [
            "remaining" :   self.remainingPass,
            "level"     :   self.currentLevel,
            "time"      :   self.currentSecondaryLevel
        ]
        return powerUpRecord
    }
    
    func importRecordObject(record: [String: Int]){
        
        if let result = record["remaining"]{
            self.remainingPass = result
        }
        
        if let result = record["level"]{
            self.currentLevel = result
        }
        
        if let result = record["time"]{
            self.currentSecondaryLevel = result
        }
    }
    
    func usePowerUp(){
        self.remainingPass -= 1
        self.powerUpUsed = true
        MinesLover.powerUpMode = type
        MinesLover.record.saveRecord()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "powerUpStart"), object: nil, userInfo: [:])
        
    }

    
    
}


