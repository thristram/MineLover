//
//  EnmuTypes.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation


enum RegisteredPurchase: String {
    
    case gem5
    case gem15
    case nonConsumablePurchase
    case consumablePurchase
    case autoRenewablePurchase
    case nonRenewingPurchase
}


enum GemViewFunctions: Int{
    case gemFound
    case creazySweeperCountdown
    case multiplerMatch
}

enum PowerUpMode: Int{
    case protector
    case corrector
}


enum GameMode: Int{
    case normal
    case sweep
}

enum MenuState: Int{
    case win
    case gameOver
    case pause
}

enum TitleIconState: Int{
    case crazy
    case mine
    case heart
}
enum CurrencyType: Int{
    case coin = 1
    case gem = 2
    case realMoney = 3
}
enum PowerUpType: Int{
    case xray = 1
    case crazySweeper = 2
    case protector = 3
    
    
    static let allValues = [xray, crazySweeper, protector]
    static func getBy(rawValue: Int) -> PowerUpType{
        for i in self.allValues{
            if i.rawValue == rawValue{
                return i
            }
        }
        return self.allValues[0]
    }
}
enum DailyCheckInType: Int{
    case coin = 1
    case gem = 2
    case gemPack = 3
    static let allValues = [coin, gem, gemPack]
    
    static func getBy(rawValue: Int) -> DailyCheckInType{
        for i in self.allValues{
            if i.rawValue == rawValue{
                return i
            }
        }
        return self.allValues[0]
    }
}
enum StoreItemName: Int{
    case xray = 1
    case crazySweeper = 2
    case protector = 3
    case coin =  4
    case gem = 5
}
enum StoreItemType: Int{
    case passes
    case abilitiesLevel
    case abilitiesTime
    case currency
}
