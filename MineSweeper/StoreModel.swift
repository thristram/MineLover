//
//  StoreModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/23/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit


class StoreItem{
    var displayName: String = ""
    var nameSufix:String = ""
    var shortCode: String = ""
    var description: String = ""
    var price: Int = 0
    var numberOfProducts: Int = 1
    var priceUnit: CurrencyType = .coin
    var productType: StoreItemType = .passes
    var productCategory: StoreItemName = .xray
    var forLevel: Int?
    
    var productsLeft: Int = 0
    var ifLocked: Bool = false
    var soldOutFlag: Bool = false
    var maxProducts:Int = 5
    
    var soldOutText:String = ""
    var lockText:String = ""
    var claimIntval:Int = 0
    
    init(price: Int?, priceUnit: CurrencyType, productType: StoreItemType, productCategory: StoreItemName, numberOfProducts:Int = 1, forLevel: Int? = nil){
        
        if let pprice = price{
            self.price = pprice
        }   else    {
            self.soldOutFlag = true
        }
        
        self.numberOfProducts = numberOfProducts
        self.priceUnit = priceUnit
        self.productType = productType
        self.productCategory = productCategory
        self.forLevel = forLevel
        
        switch productCategory {
        case .coin:
            self.displayName = "\(numberOfProducts) Coins"
            break
        case .gem:
            self.displayName = "\(numberOfProducts) Gems"
            break
        case .crazySweeper:
            self.shortCode = "sweeper"
            if productType == .abilitiesLevel{
                self.displayName = "Crazy-Sweep"
            }   else if productType == .abilitiesTime   {
                self.displayName = "Crazy Time"
            }
            
            break
        case .xray:
            self.shortCode = "xray"
            self.displayName = "X-Ray"
            break
        case .protector:
            self.shortCode = "protector"
            self.displayName = "Protector"
            break
        }
        
    }
    
    func getName() -> String{
        if (self.productType == .abilitiesLevel) || (self.productType == .abilitiesTime){
            if self.nameSufix == ""{
                return self.displayName.uppercased()
            }   else    {
                return self.displayName.uppercased() + " " + self.nameSufix
            }
        }   else    {
            return self.displayName.uppercased()
        }
    }
    func getSufix() -> String{
        return self.nameSufix
    }
    
    func getCurrentData(){
        if let powerUp = MinesLover.getPowerUpBy(storeItemName: self.productCategory){
            
            switch self.productType{
            case .abilitiesLevel:
                self.nameSufix = powerUp.levels[self.forLevel!]!.displayText
                self.productsLeft = powerUp.currentLevel
                self.soldOutText = "Fully Upgraded"
                break
            case .abilitiesTime:
                self.nameSufix = powerUp.secondaryLevels[self.forLevel!]!.displayText
                self.productsLeft = powerUp.currentSecondaryLevel
                self.soldOutText = "Fully Upgraded"
                self.lockText = "Pleas Unlock \(powerUp.name) First"
                if powerUp.currentLevel == 0{
                    self.ifLocked = true
                }   else    {
                    self.ifLocked = false
                }
                break
            case .passes:
                self.productsLeft = powerUp.remainingPass
                self.soldOutText = "5 is Enough, Man!"
                self.lockText = "Pleas Unlock \(powerUp.name) First"
                if powerUp.currentLevel == 0{
                    self.ifLocked = true
                }   else    {
                    self.ifLocked = false
                }
                
                if self.maxProducts == self.productsLeft {
                    self.soldOutFlag = true
                }
                break
            case .deal:
                let currentTime = Int(MinesLover.publicMethods.getTimestamp())!
                if let lastClaim = MinesLover.record.getKeyValueRecord(key: self.shortCode){
                    if (currentTime - Int(lastClaim)!) > self.claimIntval{
                        self.soldOutFlag = false
                    }   else    {
                        self.soldOutFlag = true
                    }
                }   else    {
                    self.soldOutFlag = false
                }
                
                break
                
            default:
                break
            }
        }   else{
            switch self.productCategory{
            case .coin:
                self.productsLeft = MinesLover.Coins
                break
            case .gem:
                self.productsLeft = MinesLover.Gems
                break
            default:
                break
                
            }
        }
    }
}



class Store{
    
    ////////////////////////////////
    ////////////STORE KIT///////////
    ////////////////////////////////
    
    let appBundleId = "SeraphTechnology.MineSweeper"
    let purchaseGem5Suffix = RegisteredPurchase.gem5
    let purchaseGem15Suffix = RegisteredPurchase.gem15
    
    
    var products: [StoreItem] = []
    
    func addProduct(item: StoreItem){
        self.products.append(item)
    }
    
    func getAllEligibleProducts() -> [StoreItem]{
        var result: [StoreItem] = []
        for product in self.products{
            product.getCurrentData()
            if let forLevel = product.forLevel{
                if let powerUp = MinesLover.getPowerUpBy(storeItemName: product.productCategory){
                    
                    switch product.productType{
                    case .abilitiesTime:
                        if forLevel == powerUp.currentSecondaryLevel{
                            result.append(product)
                        }
                        break
                    default:
                        if forLevel == powerUp.currentLevel{
                            result.append(product)
                        }
                        break
                    }
 
                }
            }   else    {
                switch product.productCategory{
                case .coin:
                    product.productsLeft = MinesLover.Coins
                    break
                case .gem:
                    product.productsLeft = MinesLover.Gems
                    break
                default:
                    break
                    
                }
                result.append(product)
            }
        }
        return result
    }
    
    func getProductBy(type: [StoreItemType], category: StoreItemName? = nil) -> [StoreItem]{
        var result: [StoreItem] = []
        for product in self.getAllEligibleProducts(){
            if type.contains(product.productType){
                if let _ = category {
                    if product.productCategory == category{
                        result.append(product)
                    }
                }   else{
                    result.append(product)
                }
            }
        }
        return result
    }
    
    
    init(){
        
    }
    
    
    func purchase(item: StoreItem, vc: UIViewController){
        
        let powerUp = MinesLover.getPowerUpBy(storeItemName: item.productCategory)
        
    
        if !item.ifLocked{
            if !item.soldOutFlag{
                
                if item.priceUnit == .realMoney{
                    SwiftyStoreKit.purchaseProduct(RegisteredPurchase.gem5.rawValue, quantity: 1, atomically: true) { result in
                        switch result {
                        case .success(let purchase):
//                            vc.notifyUser("Success", message: "\(purchase.productId)")
                            print("Purchase Success: \(purchase.productId)")
                            if item.productCategory == .coin{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Coins!", type: .coinEarned)
                                MinesLover.setCoins(coins: MinesLover.Coins + item.numberOfProducts)
                            }
                            if item.productCategory == .gem{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Gems!", type: .gemEarned)
                                MinesLover.setGems(gems: MinesLover.Gems + item.numberOfProducts)
                            }
                        case .error(let error):
                            switch error.code {
                            case .unknown: vc.notifyUser("Error", message: "Unknown error. Please contact support")
                            case .clientInvalid: vc.notifyUser("Error", message: "Not allowed to make the payment")
                            case .paymentCancelled: break
                            case .paymentInvalid: vc.notifyUser("Error", message: "The purchase identifier was invalid")
                            case .paymentNotAllowed: print("The device is not allowed to make the payment")
                            case .storeProductNotAvailable: print("The product is not available in the current storefront")
                            case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                            case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                            case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                            }
                        }
                    }

                }   else    {
                    if(self.virtualSales(price: item.price, currencyType: item.priceUnit)){
                        switch item.productType{
                        case .abilitiesLevel:
                            powerUp?.currentLevel += item.numberOfProducts
                            break
                        case .abilitiesTime:
                            powerUp?.currentSecondaryLevel += item.numberOfProducts
                            break
                        case .passes:
                            powerUp?.remainingPass += item.numberOfProducts
                            break
                        case .deal:
                            let currentTimeStamp = MinesLover.publicMethods.getTimestamp()
                            MinesLover.record.saveKeyValueRecord(key: item.shortCode, value: currentTimeStamp)
                            if item.productCategory == .coin{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Coins!", type: .coinEarned)
                                MinesLover.setCoins(coins: MinesLover.Coins + item.numberOfProducts)
                            }
                            if item.productCategory == .gem{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Gems!", type: .gemEarned)
                                MinesLover.setGems(gems: MinesLover.Gems + item.numberOfProducts)
                            }
                            break
                        case .currency:
                            
                            if item.productCategory == .coin{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Coins!", type: .coinEarned)
                                
                                MinesLover.setCoins(coins: MinesLover.Coins + item.numberOfProducts)
                            }
                            if item.productCategory == .gem{
                                vc.notifyUser("Congratulations", message: "You Got \(item.numberOfProducts) Gems!", type: .gemEarned)
                                MinesLover.setGems(gems: MinesLover.Gems + item.numberOfProducts)
                            }
                            break
                        }
                        item.getCurrentData()
                        MinesLover.record.saveRecord()
                    }   else    {
                        vc.notifyUser("CAUTION", message: "Insufficient Fund")
                    }
                }
                
                
                
            }   else{
                if item.soldOutText != ""{
                    vc.notifyUser("CAUTION", message: item.soldOutText)
                }   else    {
                    vc.notifyUser("CAUTION", message: "This item is Sold Out!")
                }
                
            }
            
        }   else    {
            if item.lockText != ""{
                vc.notifyUser("CAUTION", message: item.lockText)
            }   else    {
                vc.notifyUser("CAUTION", message: "This item is Locked!")
            }
            
        }
            
    }
    
    func virtualSales(price: Int, currencyType: CurrencyType) -> Bool{
        switch(currencyType){
        case .coin:
            let newBlance = MinesLover.Coins - price
            if(newBlance >= 0){
                MinesLover.setCoins(coins: newBlance)
                MinesLover.record.saveRecord()
                return true
            }   else{
                return false;
            }
        case .gem:
            let newBlance = MinesLover.Gems - price
            if(newBlance >= 0){
                MinesLover.setGems(gems: newBlance)
                MinesLover.record.saveRecord()
                return true
            }   else{
                return false;
            }
       
        default:
            return false
            
        }

    }
}
