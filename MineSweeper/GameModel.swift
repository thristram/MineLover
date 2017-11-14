//
//  GameModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit



class HintSystem{
    //Hint System
    var inactivityTime:Int = 0
    var maxInactivityTime: Int = 500
    
    init(){
        
    }
    
    
    func resetHintTime(){
        self.inactivityTime = maxInactivityTime
    }
    func hintTimeCountdown(){
        if self.inactivityTime > 0 {
            self.inactivityTime -= 1
        }   else    {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inactivityActive"), object: nil, userInfo: [:])
        }
        
        
    }
}

class MineLover{

    var newGame:Bool = true
    var isLevelChanged: Bool = false
    var timerMode: TimerMode = .normal

    ////////////////////////////////////
    //////////Game Statistics///////////
    ////////////////////////////////////
    
    var Gems: Int = 0
    var Coins: Int = 0
    var currentLevel:Int = 2
    
    //Current Game Statistics
    
    var sweeped:Int = 0;
    var sweepCorrected:Int = 0;
    var sweepNotCorrected:Int = 0;
    var checked:Int = 0
    
    //Timer
    
    var timerCounter = 0
    
    //Map
    
    var currentMap = ""
    
    //Gem System
    var gemProbability: Double = 0.1
    var gemContentlimit: Int = 5
    
    //Mode
    
    var gameState: GameState = .pendingStart
    var powerUpMode: PowerUpType = .none
    var gameMode: GameMode = .normal
    
    //Objects
    
    
    var levels: [Int: MLevel] = [:]
    var UIElements: [String: Double] = [:]
    var powerUps : [PowerUpType: PowerUp] = [:]
    var publicMethods = PublicMethods()
    var record: Record = Record()
    var store: Store = Store()
    
    //Device Variables
    
    var HDIdentifier: String = ""
    var isiPad: Bool = false
    var deviceID: String
    
    //Settings
    
    var enablePowerUps = true
    
    //Hint System
    var hintSystem: HintSystem = HintSystem()
    
    
    init(){
        self.deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.initUIElements()
        self.initLevel()
        self.initPowerUps()
        self.initStore()
        
        if(self.isiPad){
            self.HDIdentifier = "HD"
        }
        
    }
    func initStorage(){
        self.record.initRecord()
    }
    
    func initStore(){
        var item: StoreItem
        item = StoreItem(price: 1000, priceUnit: .coin, productType: .passes, productCategory: .xray)
        item.description =  "Wanna see what's undergrould?"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 1500, priceUnit: .coin, productType: .passes, productCategory: .crazySweeper)
        item.description =  "Go Crazy and CLICK EVERYWHERE!"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5000, priceUnit: .coin, productType: .passes, productCategory: .protector)
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
        item.shortCode = "coin_s"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 2, priceUnit: .gem, productType: .currency, productCategory: .coin, numberOfProducts: 4500)
        item.description =  "Buy 4500 Coins with 2 gems"
        item.shortCode = "coin_m"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 5, priceUnit: .gem, productType: .currency, productCategory: .coin, numberOfProducts: 12000)
        item.description =  "Buy 12000 Coins with 5 gems"
        item.shortCode = "coin_l"
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 1, priceUnit: .realMoney, productType: .currency, productCategory: .gem, numberOfProducts: 5)
        item.description =  "Buy 12000 Coins with 5 gems"
        item.shortCode = "coin_l"
        item.displayName = "5 Gems"
        self.store.addProduct(item: item)
        
        
        //Deals
        item = StoreItem(price: 0, priceUnit: .coin, productType: .deal, productCategory: .coin, numberOfProducts: 5000)
        item.displayName = "Gift Coins by TT"
        item.description =  "Free Coins from TT"
        item.shortCode = "deals_coin_s"
        item.soldOutText = "Please Come and Check Again Tomorrow!"
        item.claimIntval = 86400
        self.store.addProduct(item: item)
        
        item = StoreItem(price: 0, priceUnit: .coin, productType: .deal, productCategory: .gem, numberOfProducts: 2)
        item.displayName = "Gift Gems by TT"
        item.description = "Free Gems from TT"
        item.shortCode = "deals_gem_s"
        item.soldOutText = "Please Come and Check Again Tomorrow!"
        item.claimIntval = 86400
        self.store.addProduct(item: item)
        
//        item = StoreItem(price: 0, priceUnit: .coin, productType: .deal, productCategory: .gem, numberOfProducts: 50)
//        item.displayName = "Gift Gem Pack by TT"
//        item.description = "Free Gem Pack from TT"
//        item.shortCode = "deals_gem_m"
//        item.soldOutText = "Please Come and Check Again Next Week!"
//        item.claimIntval = 604800
//        self.store.addProduct(item: item)
//        
        
        
        
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
        self.gameState = .pendingStart
        self.powerUpMode = .none
        self.gameMode = .normal
        self.timerCounter = 0
        self.timerMode = .normal
        
        for (_, powerUp) in self.powerUps{
            powerUp.powerUpUsed = false
            powerUp.resetRemainings()
        }
        
        self.sweeped = 0;
        self.sweepCorrected = 0;
        self.sweepNotCorrected = 0;
        self.checked = 0;
    }
    
    func incTimer() -> Int{
        self.timerCounter += 1
        return self.timerCounter
    }
    
    func getPowerUpRemainingFunctions(type: PowerUpType) -> Int{
        return self.powerUps[type]!.remainingFunctios
    }
    func setPowerUpRemainingFunctions(type: PowerUpType, value: Int) {
        self.powerUps[type]!.remainingFunctios = value
    }
    func decPowerUpRemainingFunctions(type: PowerUpType, by: Int = 1){
        self.powerUps[type]!.remainingFunctios -= by
    }
    func startNewGame(){
        self.newGame = true
    }
    
    func gameOver(){
        self.gameState = .lose
        self.getCurrentLevel().record.saveRecord(ifWin: false)
    }
    
    func gameWin(){
        self.gameState = .win
        self.getCurrentLevel().record.saveRecord(ifWin: true)
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
    func getLevelTitle(level:Int) -> String{
        let selectedLevel = self.getLevel(level: level)
        return "\(selectedLevel.levelName.uppercased()) \(selectedLevel.width)x\(selectedLevel.height)"
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
    
    func setCoins(coins: Int){
        self.Coins = coins
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCoins"), object: nil, userInfo: [:])
    }
    
    func setGems(gems: Int){
        self.Gems = gems
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGems"), object: nil, userInfo: [:])
    }
    
    
    

    
    func configiPhone(){
        switch(self.screenSize()){
        case "5":
            let lv1 = self.getLevel(level: 1)
            lv1.scale = 1.21
            lv1.marginTop = 2
            lv1.marginLeft = 5
            
            let lv2 = self.getLevel(level: 2)
            lv2.scale = 1.21
            lv2.marginTop = 2
            lv2.marginLeft = 5
            
            let lv3 = self.getLevel(level: 3)
            lv3.scale = 0.956
            lv3.marginTop = 2
            lv3.marginLeft = 8
            
            let lv4 = self.getLevel(level: 4)
            lv4.scale = 0.62
            lv4.marginTop = 3
            lv4.marginLeft = 2
            
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
        case "X":
            let lv1 = self.getLevel(level: 1)
            lv1.scale = 1.46
            lv1.marginTop = 5
            lv1.marginLeft = 1.5
            
            let lv2 = self.getLevel(level: 2)
            lv2.scale = 1.46
            lv2.marginTop = 5
            lv2.marginLeft = 1.5
            
            let lv3 = self.getLevel(level: 3)
            lv3.scale = 1.15
            lv3.marginTop = 1
            lv3.marginLeft = 4
            lv3.tdHeight = 32
            
            let lv4 = self.getLevel(level: 4)
            lv4.scale = 0.73
            lv4.marginTop = 0
            lv4.marginLeft = 2
            break
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
            
            
            let lv2 = self.getLevel(level: 2)
            lv2.width = 17
            lv2.height = 12
            lv2.mines = 30
            
            
            let lv3 = self.getLevel(level: 3)
            lv3.width = 17
            lv3.height = 12
            lv3.mines = 40
            
            
            let lv4 = self.getLevel(level: 4)
            lv4.width = 26
            lv4.height = 18
            lv4.mines = 99
            
            
            
            switch(self.screenSize()){
            case "iPad-12.9":
                lv1.scale = 3.27
                lv1.marginTop = 3
                lv1.marginLeft = 2
                
                lv2.scale = 2.49
                lv2.marginTop = 2
                lv2.marginLeft = 3.5
                lv2.tdHeight = 32
                
                lv3.scale = 2.49
                lv3.marginTop = 2
                lv3.marginLeft = 3.5
                lv3.tdHeight = 32
                
                lv4.scale = 1.64
                lv4.marginTop = 6
                lv4.marginLeft = 2
                
                break
                
            case "iPad-10.5":
                lv1.scale = 2.63
                lv1.marginTop = 3
                lv1.marginLeft = 5
                
                lv2.scale = 1.9999
                lv2.marginTop = 3
                lv2.marginLeft = 7
                lv2.tdHeight = 32
                
                lv3.scale = 1.9999
                lv3.marginTop = 3
                lv3.marginLeft = 7
                lv3.tdHeight = 32
                
                lv4.scale = 1.33
                lv4.marginTop = 3
                lv4.marginLeft = 4
                
                break
                
            case "iPad":
                lv1.scale = 2.41
                lv1.marginTop = 2
                lv1.marginLeft = 5
                
                lv2.scale = 1.83
                lv2.marginTop = 2
                lv2.marginLeft = 8
                lv2.tdHeight = 32
                
                lv3.scale = 1.83
                lv3.marginTop = 2
                lv3.marginLeft = 8
                lv3.tdHeight = 32
                
                lv4.scale = 1.21
                lv4.marginTop = 5
                lv4.marginLeft = 7
                
                break
            default:
                break
                
            }
        }
        
    }
    
    func screenSize() -> String{
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        print("screen Height: \(screenHeight)")
        self.UIElements["statusBarHeight"] = 70
        self.UIElements["menuBottomHeight"] = 10
        self.UIElements["storePargerBarTop"] = 54
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
        case 812:
            self.UIElements["storePriceButtonTitleOffset"] = -80
            self.UIElements["statusBarHeight"] = 100
            self.UIElements["menuBottomHeight"] = 25
            self.UIElements["storePargerBarTop"] = 84
            return "X"
        case 768:
            self.isiPad = true
            print("iPad")
            return "iPad"
        case 834:
            self.isiPad = true
            print("iPad-10.5")
            return "iPad-10.5"
        case 1366:
            self.isiPad = true
            print("iPad-12.9")
            return "iPad-12.9"
        default:
            return ""
        }

    }
    

    
}



class PublicMethods{
    init(){
        
    }
    
    func getTimestamp() -> String{
        return "\(Int(NSDate().timeIntervalSince1970))";
    }
    func timestamp2Date(timestamp: Int) -> String{
        let date = NSDate(timeIntervalSince1970: Double(timestamp))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
        
        
        
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
    func sec2Min(time: Int) -> String{
        
        let sec = time
        let newSec = sec%60
        var newSecStr = "\(newSec)"
        if(newSec < 10){
            newSecStr = "0\(newSec)"
        }
        return ("\(sec/60):\(newSecStr)")
        
    }
    
}
