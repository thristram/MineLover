//
//  GameModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit


/*
var mapConfigs : [[String: String]] = [
    
    ["width" : "8", "height" : "13", "setMines" : "12", "setScale" : "1.6", "setScaleable": "yes", "setMaxScale" : "1.0", "setMinScale" : "1.0", "marginTop" : "2", "marginLeft": "2", "tdWidth" : "32", "tdHeight" : "32", "divWidth": "30", "divHeight": "30", "iconFontSize": "150%", "fontSize": "100%" ],
    
    ["width" : "8", "height" : "13", "setMines" : "20", "setScale" : "1.6", "setScaleable": "yes", "setMaxScale" : "1.0", "setMinScale" : "1.0", "marginTop" : "2", "marginLeft": "2", "tdWidth" : "32", "tdHeight" : "32", "divWidth": "30", "divHeight": "30", "iconFontSize": "150%", "fontSize": "100%" ],
    
    ["width" : "10", "height" : "17", "setMines" : "35", "setScale" : "1.28", "setScaleable": "yes", "setMaxScale" : "2.0", "setMinScale" : "1.0", "marginTop" : "2", "marginLeft": "3", "tdWidth" : "32", "tdHeight" : "31", "divWidth": "30", "divHeight": "30", "iconFontSize": "150%", "fontSize": "100%" ],
    
    ["width" : "16", "height" : "26", "setMines" : "90", "setScale" : "0.8", "setScaleable": "yes", "setMaxScale" : "2.0", "setMinScale" : "1.0", "marginTop" : "10", "marginLeft": "4", "tdWidth" : "32", "tdHeight" : "32", "divWidth": "30", "divHeight": "30", "iconFontSize": "150%", "fontSize": "100%" ],
    
]
*/

class MineLover{
    var isiPad: Bool = false
    var levels: [Int: MLevel] = [:]
    var currentLevel:Int = 3
    var newGame:Bool = false
    
    var isGameOvered:Bool = false;
    var isGameWined:Bool = false;
    
    var Gems: Int = 0
    var Coins: Int = 10000
    
    
    var sweeped:Int = 0;
    var sweepCorrected:Int = 0;
    var sweepNotCorrected:Int = 0;
    var checked:Int = 0
    
    var HDIdentifier: String = ""
    
    var currentMap = ""
    
    var publicMethods = PublicMethods()
    var powerUps : [PowerUpType: PowerUp] = [:]
    var record: Record = Record()
    var store: Store = Store()
    var dailyCheckIns: [DailyCheckInType: DailyCheckIn] = [:]
    
    var UIElements: [String: Double] = [:]
    
    init(){
        self.initUIElements()
        self.initLevel()
        self.initPowerUps()
        self.initStore()
        self.initDailyCheckIn()
        if(self.isiPad){
            self.HDIdentifier = "HD"
        }
        
    }
    
    func initStore(){
        var item: StoreItem
        item = StoreItem(price: 1000, priceUnit: .coin, productType: .passes, productCategory: .xray)
        item.description =  "Wanna see what's undergrould?"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 1500, priceUnit: .coin, productType: .passes, productCategory: .crazySweeper)
        item.description =  "Go Crazy and CLICK EVERYWHERE!"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5000, priceUnit: .gem, productType: .passes, productCategory: .xray)
        item.description =  "Never Sweep Wrong!"
        self.store.addProduct(item: item)
        
        //X-Ray Abiltity
        
        item = StoreItem(price: 2, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 0)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 3, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 1)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 2)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 8, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 3)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 10, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 4)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: nil, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .xray, forLevel: 5)
        item.description =  "Expend Mines X-Ray Range"
        self.store.addProduct(item: item)
        
        //Crazy Sweeper Abiltity
        
        item = StoreItem(price: 2, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 0)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 3, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 1)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 2)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 8, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 3)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 10, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 4)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: nil, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .crazySweeper, forLevel: 5)
        item.description =  "Expend Crazy Sweep Range"
        self.store.addProduct(item: item)
        
        //Crazy Sweeper Time
        
        item = StoreItem(price: 2, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 0)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 3, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 1)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 4, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 2)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 3)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 6, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 4)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: nil, priceUnit: .gem, productType: .abilitiesTime, productCategory: .crazySweeper, forLevel: 5)
        item.description =  "Expend Crazy Sweep Time"
        self.store.addProduct(item: item)
        
        //Protector Abiltity
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 0)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 10, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 1)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 20, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 2)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 30, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 3)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 50, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 4)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: nil, priceUnit: .gem, productType: .abilitiesLevel, productCategory: .protector, forLevel: 5)
        item.description =  "Increase Miss-Sweep Limit"
        self.store.addProduct(item: item)
        
        //Currency
        
        item = StoreItem(price: 1, priceUnit: .gem, productType: .currency, productCategory: .coin, numberOfProducts: 2000)
        item.description =  "Buy 2000 Coins with 1 gem"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 2, priceUnit: .gem, productType: .currency, productCategory: .coin, numberOfProducts: 4500)
        item.description =  "Buy 4500 Coins with 2 gems"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .currency, productCategory: .coin, numberOfProducts: 12000)
        item.description =  "Buy 12000 Coins with 5 gems"
        self.store.addProduct(item: item)
        
        
    }
    func initUIElements(){
        self.UIElements["storePriceButtonTitleOffset"] = -127.0
        _ = self.screenSize()
        
    }
    func initPowerUps(){
        for type in PowerUpType.allValues{
            self.powerUps[type] = PowerUp(powerUpType: type)
        }
    }
    func initDailyCheckIn(){
        for type in DailyCheckInType.allValues{
            self.dailyCheckIns[type] = DailyCheckIn(type: type)
        }
    }
    func initLevel(){
        let lv1 = MLevel(level: 1, levelName: "Beginner", width: 8, height: 13, mines: 12, scale: 1.6, marginTop: 2, marginLeft: 2)
        let lv2 = MLevel(level: 2, levelName: "Meidum", width: 8, height: 13, mines: 20, scale: 1.6, marginTop: 2, marginLeft: 2)
        let lv3 = MLevel(level: 3, levelName: "Hard", width: 10, height: 17, mines: 35, scale: 1.28, maxScale: 2.0, marginTop: 2, marginLeft: 3, tdHeight: 31)
        let lv4 = MLevel(level: 4, levelName: "Crazy", width: 16, height: 26, mines: 90, scale: 0.8, maxScale: 2.0, marginTop: 10, marginLeft: 4)
        
        self.levels[1] = lv1
        self.levels[2] = lv2
        self.levels[3] = lv3
        self.levels[4] = lv4
        self.configiPhone()
        self.configiPad()
        
    }
    func initNewGame(){
        self.newGame = false
        self.isGameOvered = false;
        self.isGameWined = false;
        
        self.sweeped = 0;
        self.sweepCorrected = 0;
        self.sweepNotCorrected = 0;
        self.checked = 0;
    }
    func startNewGame(){
        self.newGame = true
        
    }
    
    func gameOver(){
        self.isGameOvered = true;
    }
    
    func gameWin(){
        self.isGameWined = true;
    }
    
    func getLevel(level:Int) -> MLevel{
        return self.levels[level]!
    }
    func getCurrentLevel() -> MLevel{
        return self.getLevel(level: self.currentLevel)
    }
    func getCurrentLevelMines() -> Int{
        return self.getCurrentLevel().mines
    }
    func getISScrollEnabled() -> Bool{
        if currentLevel == 4{
            return true
        }   else{
            return false
        }
    
    }
    
    func getMinesRemaining() -> Int{
        let totalMines = self.getCurrentLevelMines()
        return (totalMines - self.sweeped)
    }
    
    func getPowerUpBy(storeItemName: StoreItemName) -> PowerUp?{
        if let powerUp = self.powerUps[PowerUpType.getBy(rawValue: storeItemName.rawValue)]{
            return powerUp
        }   else{
            return nil
        }
    }
    
    func setCurrentLevel(newLevel:Int){
        if newLevel == self.currentLevel{
            
        }   else{
            self.newGame = true
        }
    }
    
   
    
    
    

    
    func configiPhone(){
        switch(self.screenSize()){
        case "5":
            break;
        case "7":
            let lv1 = self.getLevel(level: 1)
            lv1.scale = 1.46
            lv1.marginTop = 0
            lv1.marginLeft = 1.5
            
            let lv2 = self.getLevel(level: 2)
            lv2.scale = 1.46
            lv2.marginTop = 0
            lv2.marginLeft = 1.5
            
            let lv3 = self.getLevel(level: 3)
            lv3.scale = 1.15
            lv3.marginTop = 1
            lv3.marginLeft = 4
            
            let lv4 = self.getLevel(level: 4)
            lv4.scale = 0.73
            lv4.marginTop = 0
            lv4.marginLeft = 2
            break;
        case "7+":
            break;
        default:
            break;
        }
    }
    func configiPad(){
        if self.isiPad{
            for i in 1...4{
                let lv = self.getLevel(level: i)
                let orgWidth = lv.width
                let orgHeight = lv.height
                lv.width = orgHeight
                lv.height = orgWidth
                
            }
            let lv1 = self.getLevel(level: 1)
            lv1.width = 13
            lv1.height = 9
            lv1.mines = 15
            lv1.scale = 3.27
            lv1.marginTop = 3
            lv1.marginLeft = 2
            
            let lv2 = self.getLevel(level: 2)
            lv2.width = 17
            lv2.height = 12
            lv2.mines = 30
            lv2.scale = 2.49
            lv2.marginTop = 2
            lv2.marginLeft = 3.5
            lv2.tdHeight = 32
            
            let lv3 = self.getLevel(level: 3)
            lv3.width = 17
            lv3.height = 12
            lv3.mines = 40
            lv3.scale = 2.49
            lv3.marginTop = 2
            lv3.marginLeft = 3.5
            lv3.tdHeight = 32
            
            let lv4 = self.getLevel(level: 4)
            
            lv4.width = 26
            lv4.height = 18
            lv4.mines = 99
            lv4.scale = 1.64
            lv4.marginTop = 6
            lv4.marginLeft = 2
        }
        
    }
    
    func screenSize()->String{
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        
        switch screenHeight{
        case 480:
            return "4"
        case 568:
            return "5"
        case 667:
            return "7"
        case 736:
            self.UIElements["storePriceButtonTitleOffset"] = -80
            return "7+"
        case 1024:
            
            self.isiPad = true
            
            if(screenWidth == 768){
                return "iPad"
            }   else if(screenWidth == 1366){
                return "iPad-12.9"
            }
            
        case 1112:
            self.isiPad = true
            return "iPad-10.5"
        case 1366:
            self.isiPad = true
            return "iPad-12.9"
        default:
            return ""
        }
        return "";
    }
    

    
}



class PublicMethods{
    init(){
        
    }
    
    func getTimestamp() -> String{
        return "\(Int(NSDate().timeIntervalSince1970))";
    }
    func timestamp2Date(timestamp: String) -> String{
        if let ts = Int(timestamp){
            let date = NSDate(timeIntervalSince1970: Double(ts))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString
            
        }   else{
            let date = NSDate(timeIntervalSince1970: 0.0)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString
            
        }
        
        
        
    }
    func formatMineDisplay(mineInput: Int) -> String{
        var mi = mineInput;
        var displayedMine = "";
        var mineSign = "";
        
        if(mineInput < 0){
            mineSign = "-";
            mi = mineInput * (-1)
        }
        
        if(mi < 10){
            displayedMine = "\(mineSign)00\(mi)"
        }   else if(mi < 100){
            displayedMine = "\(mineSign)0\(mi)"
        }   else{
            displayedMine = "\(mineSign)\(mi)"
        }
        return displayedMine
        
    }
    
    
    
    func min2Sec(time: String) -> Int{
        
        let timeArr = time.characters.split{$0 == ":"}.map(String.init)
        return (Int(timeArr[0])! * 60 + Int(timeArr[1])!)
        
    }
    func sec2Min(time: String) -> String{
        
        let sec = Int(time)!
        let newSec = sec%60
        var newSecStr = "\(newSec)"
        if(newSec < 10){
            newSecStr = "0\(newSec)"
        }
        return ("\(sec/60):\(newSecStr)")
        
    }
}
