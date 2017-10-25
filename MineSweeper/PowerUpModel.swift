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
    var storeDescription: String = ""
    var storeShortCode: String = ""
    var type: PowerUpType = .xray
    var levels: [Int:PowerUpLevel] = [:]
    var secondaryLevels: [Int:PowerUpLevel] = [:]
    
    var currentLevel: Int = 1
    var currentSecondaryLevel: Int = 0
    var remainingPass: Int = 2
    
    init(powerUpType: PowerUpType){
        switch(powerUpType){
        case .xray:
            self.name = "Mines X-Ray"
            self.discription = "Wanna see what's underground?"
            self.storeDescription = "Expand Mines X-Ray Range"
            self.storeShortCode = "xray"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "[LOCKED]", value: 0, secondaryValue: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "1x3", value: 1, secondaryValue: 3)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "2x3", value: 2, secondaryValue: 3)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "3x3", value: 3, secondaryValue: 3)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "5x3", value: 5, secondaryValue: 3)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "5x3", value: 5, secondaryValue: 5)
            break
        case .crazySweeper:
            self.name = "Crazy Sweeper"
            self.discription = "Go CRAZY and click EVERYWHERE!"
            self.storeDescription = "Expand Crazy Click Range"
            self.storeShortCode = "sweeper"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "[LOCKED]", value: 0, secondaryValue: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "5x5", value: 5, secondaryValue: 5)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "8x13", value: 8, secondaryValue: 13)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "10x17", value: 10, secondaryValue: 17)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "12x20", value: 12, secondaryValue: 20)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "Unlimited", value: 100, secondaryValue: 100)
            
            self.secondaryLevels[0] = PowerUpLevel(levelNumber:0, displayText: "1s", value: 1)
            self.secondaryLevels[1] = PowerUpLevel(levelNumber:1, displayText: "2s", value: 2)
            self.secondaryLevels[2] = PowerUpLevel(levelNumber:2, displayText: "3s", value: 3)
            self.secondaryLevels[3] = PowerUpLevel(levelNumber:3, displayText: "4s", value: 4)
            self.secondaryLevels[4] = PowerUpLevel(levelNumber:4, displayText: "5s", value: 5)
            self.secondaryLevels[5] = PowerUpLevel(levelNumber:5, displayText: "6s", value: 6)
            
            break
        case .protector:
            self.name = "Miss-Sweep Proof"
            self.discription = "Never SWEEP WRONG"
            self.storeDescription = "Increase Miss-Sweep Limit"
            self.storeShortCode = "corrector"
            self.levels[0] = PowerUpLevel(levelNumber:0, displayText: "[LOCKED]", value: 0)
            self.levels[1] = PowerUpLevel(levelNumber:1, displayText: "1", value: 1)
            self.levels[2] = PowerUpLevel(levelNumber:2, displayText: "2", value: 2)
            self.levels[3] = PowerUpLevel(levelNumber:3, displayText: "3", value: 3)
            self.levels[4] = PowerUpLevel(levelNumber:4, displayText: "4", value: 4)
            self.levels[5] = PowerUpLevel(levelNumber:5, displayText: "5", value: 5)
            break
            
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
        
    }
    
    
    
}

class DailyCheckIn{
    var type: DailyCheckInType
    var lastClaim: Int = 0
    var claimIntval: Int
    var name: String
    var amount: Int
    
    init(type: DailyCheckInType){
        self.type = type
        switch type{
        case .coin:
            self.name = "Coin"
            self.amount = 5000
            self.claimIntval = 86400
            break
        case .gem:
            self.name = "Gem"
            self.amount = 2
            self.claimIntval = 86400
            break
        case .gemPack:
            self.name = "Gem Pack"
            self.amount = 50
            self.claimIntval = 604800
        }
        self.loadFromStorage()
    }
    func loadFromStorage(){
        
    }
    
    
}
