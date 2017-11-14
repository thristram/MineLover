//
//  RecordModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import GameKit
/*
var lv_1_Statistics:[String:String] = [
    "averageTime":"0", "averageTimeWin":"0", "averageTimeLose":"0", "explorationPercentage":"0", "totalWin":"0", "totalLose":"0", "totalGame":"0", "longestGame": "0", "longestWin": "0", "longestLose": "0", "shortestLose": "0", "totalChecked": "0", "totalMineSweeped":"0", "totalMineSweepedWrong": "0",
    "1_Date":"0", "2_Date":"0", "3_Date":"0", "4_Date":"0", "5_Date":"0", "6_Date":"0", "7_Date":"0", "8_Date":"0", "9_Date":"0", "10_Date":"0",
    "1_Record":"0", "2_Record":"0", "3_Record":"0", "4_Record":"0", "5_Record":"0", "6_Record":"0", "7_Record":"0", "8_Record":"0", "9_Record":"0", "10_Record":"0",
    "1_map":"{}", "2_map":"{}", "3_map":"{}", "4_map":"{}", "5_map":"{}", "6_map":"{}", "7_map":"{}", "8_map":"{}", "9_map":"{}", "10_map":"{}"
    
];
 */

class SingleRecord{
    var date: Int = 0
    var record: Int = 0
    var map: String = "{}"
    
    init(record:Int, map:String){
        self.record = record
        self.map = map
        
    }
    init(record:Int, map:String, date: Int){
        self.record = record
        self.map = map
        self.date = date
    }
}
class LevelRecord{
    
    
    var averageTime: Int = 0
    var averageTimeWin: Int = 0
    var averageTimeLose: Int = 0
    var explorationPercentage: Int = 0
    var totalWin: Int = 0
    var totalLose: Int = 0
    var totalGame: Int = 0
    var longestGame: Int = 0
    var longestWin: Int = 0
    var longestLose: Int = 0
    var shortestLose: Int = 0
    var totalChecked: Int = 0
    var totalMineSweeped: Int = 0
    var totalMineSweepedWrong: Int = 0
    
    var records: [Int:SingleRecord] = [:]
    
    init(){
        for i in 1...10{
            records[i] = SingleRecord(record: 0, map: "{}")
        }
    }
    
    func startRecord(){
        self.totalGame += 1
        MinesLover.record.saveRecord()
    }

    func saveRecord(ifWin: Bool){
        let timeUsed = MinesLover.timerCounter / 100
        let totalNumberOfBlocks = MinesLover.getCurrentLevel().height * MinesLover.getCurrentLevel().height;
        let percentageCompleted = ((MinesLover.checked * 100) / (totalNumberOfBlocks - MinesLover.getCurrentLevelMines()));
        let totalGameFinished = self.totalWin + self.totalLose;
        
        self.totalGame += 1
        self.averageTime = (self.averageTime * (self.totalGame - 1) + timeUsed) / self.totalGame
        self.totalChecked += MinesLover.checked
        self.totalMineSweeped += MinesLover.sweepCorrected
        self.explorationPercentage = (self.explorationPercentage * totalGameFinished + percentageCompleted) / (totalGameFinished + 1)
        
        if(self.longestGame < timeUsed){
            self.longestGame = timeUsed
        }
        if ifWin{
            //IF Game Win
            self.totalWin += 1
            self.averageTimeWin = (self.averageTimeWin * (self.totalWin - 1) + timeUsed) / self.totalWin
            self.uploadRecordToGameCenter(timeUsed: timeUsed)
            self.recordLeaderboard(record: timeUsed)
            if(self.longestWin < timeUsed){
                self.longestWin = timeUsed
            }
        }   else{
            //IF Game Lose
            
            self.totalLose += 1
            self.averageTimeLose = (self.averageTimeLose * (self.totalLose - 1) + timeUsed) / self.totalLose
            self.totalMineSweepedWrong += MinesLover.sweepNotCorrected
            if(self.longestLose < timeUsed){
                self.longestLose = timeUsed
            }
            if(self.shortestLose != 0){
                if(self.shortestLose > timeUsed){
                    self.shortestLose = timeUsed
                }
            }
        }
        MinesLover.record.saveRecord()

    }
    
    func recordLeaderboard(record: Int){
        
        let newRecord = SingleRecord(record: record, map: MinesLover.currentMap, date:  Int(MinesLover.publicMethods.getTimestamp())!)
        
        if records.isEmpty{
            self.records[1] = newRecord
        }   else{
            for i in (1...10).reversed(){
                if let recordToCompare = self.records[i]{
                    if recordToCompare.date == 0{
                        if i == 1{
                            self.records[1] = newRecord
                        }   else    {
                            continue
                        }
                    }   else if recordToCompare.record >= record{
                        self.records[i+1] = self.records[i]
                        self.records[i] = newRecord
                    }   else{
                        break
                    }
                }
            }
        }
        
        
    }
    
    func uploadRecordToGameCenter(timeUsed: Int){
        var levelIdentifier = ""
        var HDIdentifier = "";
        if(MinesLover.isiPad){
            HDIdentifier = "HD"
        }
        
        switch (MinesLover.currentLevel){
        case 1:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.beginner\(HDIdentifier)"
            break;
        case 2:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.medium\(HDIdentifier)"
            break;
        case 3:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.expert\(HDIdentifier)"
            break;
        case 4:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.crazy\(HDIdentifier)"
            break;
        default:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.beginner\(HDIdentifier)"
            break;
            
        }
        GCHelper.sharedInstance.reportLeaderboardIdentifier(levelIdentifier, score: timeUsed)
    }
    
    func exportRecordObject() -> [String:String]{
        var levelStatistics:[String:String] = [:]
        
        levelStatistics["averageTime"]              = String(describing: self.averageTime)
        levelStatistics["averageTimeWin"]           = String(describing: self.averageTimeWin)
        levelStatistics["averageTimeLose"]          = String(describing: self.averageTimeLose)
        levelStatistics["explorationPercentage"]    = String(describing: self.explorationPercentage)
        levelStatistics["totalWin"]                 = String(describing: self.totalWin)
        levelStatistics["totalLose"]                = String(describing: self.totalLose)
        levelStatistics["totalGame"]                = String(describing: self.totalGame)
        levelStatistics["longestGame"]              = String(describing: self.longestGame)
        levelStatistics["longestWin"]               = String(describing: self.longestWin)
        levelStatistics["longestLose"]              = String(describing: self.longestLose)
        levelStatistics["shortestLose"]             = String(describing: self.shortestLose)
        levelStatistics["totalChecked"]             = String(describing: self.totalChecked)
        levelStatistics["totalMineSweeped"]         = String(describing: self.totalMineSweeped)
        levelStatistics["totalMineSweepedWrong"]    = String(describing: self.totalMineSweepedWrong)

        
        
        for i in 1...10{
            levelStatistics["\(i)_Date"]            = String(describing: self.records[i]!.date)
            levelStatistics["\(i)_Record"]          = String(describing: self.records[i]!.record)
            levelStatistics["\(i)_map"]             = self.records[i]!.map
        }
        
        return levelStatistics
    }
    
    func importRecordObject(levelStatistics:[String:String]){
        
        if let result = levelStatistics["averageTime"]{
            self.averageTime = Int(result)!
        }
        
        if let result = levelStatistics["averageTimeWin"]{
            self.averageTimeWin = Int(result)!
        }
        
        if let result = levelStatistics["averageTimeLose"]{
            self.averageTimeLose = Int(result)!
        }
        
        if let result = levelStatistics["explorationPercentage"]{
            self.explorationPercentage = Int(result)!
        }
        
        if let result = levelStatistics["totalWin"]{
            self.totalWin = Int(result)!
        }
        
        if let result = levelStatistics["totalLose"]{
            self.totalLose = Int(result)!
        }
        
        if let result = levelStatistics["totalGame"]{
            self.totalGame = Int(result)!
        }
        
        if let result = levelStatistics["longestWin"]{
            self.longestWin = Int(result)!
        }
        
        if let result = levelStatistics["longestLose"]{
            self.longestLose = Int(result)!
        }
        
        if let result = levelStatistics["shortestLose"]{
            self.shortestLose = Int(result)!
        }
        
        if let result = levelStatistics["totalChecked"]{
            self.totalChecked = Int(result)!
        }
        
        if let result = levelStatistics["totalMineSweeped"]{
            self.totalMineSweeped = Int(result)!
        }
        
        if let result = levelStatistics["totalMineSweepedWrong"]{
            self.totalMineSweepedWrong = Int(result)!
        }
        
        for i in 1...10{
            
            if let result = levelStatistics["\(i)_Date"]{
                self.records[i]!.date = Int(result)!
            }
            
            if let result = levelStatistics["\(i)_Record"]{
                self.records[i]!.record = Int(result)!
            }
            
            if let result = levelStatistics["\(i)_map"]{
                self.records[i]!.map = result
            }
            
        }
        
    }
    
    
    
}

class Record{
    ////////////////////////////////
    ////////STORAGE VARIABLES///////
    ////////////////////////////////
    
    //iCloud
    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    let iCloudTextKey = "iCloudText"
    
    
    //Local
    var defaultKeyStore: UserDefaults = UserDefaults.standard
    let DefaultsTextKey = "DefaultsText"
    
    var localRecordLastModified = 0
    var iCloudRecordLastModified = 0
    
    var otherRecord: [String: String] = [:]
    
    
    init(){
        self.iCloudKeyStore?.synchronize()
    }
    
    func initRecord(){
        self.sync()
    }
    
    func getRecord(level: Int) -> LevelRecord?{
        if let level = MinesLover.levels[level]{
            return level.record
        }   else    {
            return nil
        }
    }
    
    func saveKeyValueRecord(key: String, value: String){
        self.otherRecord[key] = value
        self.saveRecord()
    }
    func getKeyValueRecord(key: String) -> String?{
        if let result = self.otherRecord[key]{
            return result
        }   else    {
            return nil
        }
    }
    
    func saveRecord(){
        print("RECORD SAVED");
        print("Coins: \(MinesLover.Coins), Gems: \(MinesLover.Gems)");
        let currentTime:String = MinesLover.publicMethods.getTimestamp()
        
        for (_, level) in MinesLover.levels{
            let levelRecord:[String:String] = level.record.exportRecordObject()
            self.defaultKeyStore.set(levelRecord, forKey: "lv_\(level.level)_Statistics")
            self.iCloudKeyStore?.set(levelRecord, forKey: "lv_\(level.level)_Statistics\(MinesLover.HDIdentifier)")
        }
        
        for (powerUpType, powerUp) in MinesLover.powerUps{
            let powerUpRecord = powerUp.exportRecordObject()
            self.defaultKeyStore.set(powerUpRecord, forKey: "powerUp\(powerUpType.rawValue)")
            self.iCloudKeyStore?.set(powerUpRecord, forKey: "powerUp\(powerUpType.rawValue)")
        }
        
        
        self.defaultKeyStore.set(otherRecord, forKey: "otherData")
        self.iCloudKeyStore?.set(otherRecord, forKey: "otherData")
        
        self.defaultKeyStore.set(MinesLover.Coins, forKey: "coin")
        self.defaultKeyStore.set(MinesLover.Gems, forKey: "gem")
        
        
        self.iCloudKeyStore?.set(MinesLover.Coins, forKey: "coin")
        self.iCloudKeyStore?.set(MinesLover.Gems, forKey: "gem")
        
   
        self.defaultKeyStore.set(currentTime, forKey: "localRecordLastModified")
        self.iCloudKeyStore?.set(currentTime, forKey: "iCloudRecordLastModified")
        
        self.iCloudKeyStore?.synchronize()

        
        
    }
    func sync(){
        if let iCloudLastModified = iCloudKeyStore?.string(forKey: "iCloudRecordLastModified"){
            if let localLastModified = self.defaultKeyStore.value(forKey: "localRecordLastModified") as? String{
                if Int(iCloudLastModified)! > Int(localLastModified)! {
                    self.getLocalRecord()
                    self.getiCloudRecord()
                }   else{
                    self.getLocalRecord()
                }
            }   else    {
                self.getiCloudRecord()
            }
        }
    }
    func getiCloudRecord(){
        print("Getting iCloud Data");

        if let result = iCloudKeyStore?.string(forKey: "coin"){
            print("Coins: \(result)");
            MinesLover.Coins = Int(result)!
        }
        if let result = iCloudKeyStore?.string(forKey: "gem"){
            print("Gem: \(result)");
            MinesLover.Gems = Int(result)!
        }
        
        if let result = iCloudKeyStore?.dictionary(forKey: "otherData"){
            for (key,value) in result as! [String:String] {
                otherRecord[key] = value
            }
        }
        
        for i in 1...4{
            if let result = iCloudKeyStore?.dictionary(forKey: "lv_\(i)_Statistics\(MinesLover.HDIdentifier)"){
                var levelRecord: [String: String] = [:]
                for (key,value) in result as! [String:String] {
                    levelRecord[key] = value
                }
                MinesLover.levels[i]?.record.importRecordObject(levelStatistics: levelRecord)
                
            }
        }
        for i in PowerUpType.allValues{
            let index = i.rawValue
            if let result = iCloudKeyStore?.dictionary(forKey: "powerUp\(index)"){
                var powerUpRecord: [String: Int] = [:]
                for (key,value) in result as! [String:Int] {
                    powerUpRecord[key] = value
                }
                MinesLover.powerUps[i]?.importRecordObject(record: powerUpRecord)
            }
            
        }
        
      

    }
    
    func getLocalRecord(){
        
        if let result = self.defaultKeyStore.value(forKey: "coin") as? Int{
            MinesLover.Coins = result
        }
        
        if let result = self.defaultKeyStore.value(forKey: "gem") as? Int{
            MinesLover.Gems = result
        }
        
        if let result = self.defaultKeyStore.value(forKey: "otherData"){
            for (key,value) in result as! [String:String] {
                otherRecord[key] = value
            }
        }
        
        for i in 1...4{
            if let result = self.defaultKeyStore.value(forKey: "lv_\(i)_Statistics\(MinesLover.HDIdentifier)"){
                var levelRecord: [String: String] = [:]
                for (key,value) in result as! [String:String] {
                    levelRecord[key] = value
                }
                MinesLover.levels[i]?.record.importRecordObject(levelStatistics: levelRecord)
                
            }
        }
        for i in PowerUpType.allValues{
            let index = i.rawValue
            if let result = self.defaultKeyStore.dictionary(forKey: "powerUp\(index)"){
                var powerUpRecord: [String: Int] = [:]
                for (key,value) in result as! [String:Int] {
                    powerUpRecord[key] = value
                }
                MinesLover.powerUps[i]?.importRecordObject(record: powerUpRecord)
            }
            
        }
        

    }
    
}
