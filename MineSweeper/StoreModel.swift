//
//  StoreModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/23/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit

class StoreItem{
    var displayName: String = ""
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
    
    init(price: Int?, priceUnit: CurrencyType, productType: StoreItemType, productCategory: StoreItemName, numberOfProducts:Int = 1, forLevel: Int? = nil){
        
        if let pprice = price{
            self.price = pprice
        }   else    {
            self.soldOutFlag = true
        }
        
        self.numberOfProducts = numberOfProducts
        
        self.productType = productType
        self.productCategory = productCategory
        self.forLevel = forLevel
        
        switch productCategory {
        case .coin:
            self.shortCode = "coin"
            self.displayName = "\(numberOfProducts) Coins"
            break
        case .gem:
            self.shortCode = "gem"
            self.displayName = "\(numberOfProducts) Gems"
            break
        case .crazySweeper:
            self.shortCode = "sweeper"
            self.displayName = "Crazy Sweeper"
            break
        case .xray:
            self.shortCode = "xray"
            self.displayName = "Mine X-Ray"
            break
        case .protector:
            self.shortCode = "protector"
            self.displayName = "Mine Protector"
            break
        }
    }
    
    func getCurrentData(){
        if let powerUp = MinesLover.getPowerUpBy(storeItemName: self.productCategory){
            
            switch self.productType{
            case .abilitiesLevel:
                self.displayName += powerUp.levels[self.forLevel!]!.displayText
                self.productsLeft = powerUp.currentLevel
                if powerUp.currentLevel == 0{
                    self.ifLocked = true
                }   else    {
                    self.ifLocked = false
                }
                break
            case .abilitiesTime:
                self.displayName += powerUp.levels[self.forLevel!]!.displayText
                self.productsLeft = powerUp.currentSecondaryLevel
                if powerUp.currentLevel == 0{
                    self.ifLocked = true
                }   else    {
                    self.ifLocked = false
                }
                break
            case .passes:
                self.productsLeft = powerUp.remainingPass
                if powerUp.currentLevel == 0{
                    self.ifLocked = true
                }   else    {
                    self.ifLocked = false
                }
                
                if self.maxProducts == self.productsLeft {
                    self.soldOutFlag = true
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
    
    var priceList: [String:Int] = [
        "Passes_xray" : 1000, "Passes_xray_type": 1,
        "Passes_Sweeper" : 1500, "Passes_Sweeper_type": 1,
        "Passes_Corrector" : 5000, "Passes_Corrector_type": 1,
        
        
        "Ability_xray_lv_1" : 2, "Ability_xray_lv_1_type": 2,
        "Ability_xray_lv_2" : 3, "Ability_xray_lv_2_type": 2,
        "Ability_xray_lv_3" : 5, "Ability_xray_lv_3_type": 2,
        "Ability_xray_lv_4" : 8, "Ability_xray_lv_4_type": 2,
        "Ability_xray_lv_5" : 10, "Ability_xray_lv_5_type": 2,
        
        "Ability_sweeper_lv_1" : 2, "Ability_sweeper_lv_1_type": 2,
        "Ability_sweeper_lv_2" : 3, "Ability_sweeper_lv_2_type": 2,
        "Ability_sweeper_lv_3" : 5, "Ability_sweeper_lv_3_type": 2,
        "Ability_sweeper_lv_4" : 8, "Ability_sweeper_lv_4_type": 2,
        "Ability_sweeper_lv_5" : 10, "Ability_sweeper_lv_5_type": 2,
        
        "Ability_Sweeper_time_1" : 2, "Ability_Sweeper_time_1_type": 2,
        "Ability_Sweeper_time_2" : 3, "Ability_Sweeper_time_2_type": 2,
        "Ability_Sweeper_time_3" : 4, "Ability_Sweeper_time_3_type": 2,
        "Ability_Sweeper_time_4" : 5, "Ability_Sweeper_time_4_type": 2,
        "Ability_Sweeper_time_5" : 6, "Ability_Sweeper_time_5_type": 2,
        
        "Ability_Corrector_lv_1" : 5, "Ability_Corrector_lv_1_type": 2,
        "Ability_Corrector_lv_2" : 10, "Ability_Corrector_lv_2_type": 2,
        "Ability_Corrector_lv_3" : 20, "Ability_Corrector_lv_3_type": 2,
        "Ability_Corrector_lv_4" : 30, "Ability_Corrector_lv_4_type": 2,
        "Ability_Corrector_lv_5" : 50, "Ability_Corrector_lv_5_type": 2,
        
        "Currency_1_price" : 1, "Currency_1_price_type": 2, "Currency_1_product": 2000, "Currency_1_product_type": 1,
        "Currency_2_price" : 2, "Currency_2_price_type": 2, "Currency_2_product": 4500, "Currency_2_product_type": 1,
        "Currency_3_price" : 5, "Currency_3_price_type": 2, "Currency_3_product": 12000, "Currency_3_product_type": 1,
        
        ]
    
    init(){
        
    }
    func getPrice(type: String, key: String, secondaryType: String = "", level: Int? = nil) -> Int{
        var DicKey = "\(type)_\(key)"
        if secondaryType != ""{
            DicKey += secondaryType
        }
        if level != nil {
            DicKey += "\(level!)"
        }
        if let price = self.priceList[DicKey]{
            return price
        }
        return 0
    }
    
    func getPriceType(type: String, key: String, secondaryType: String = "", level: Int? = nil) -> CurrencyType{
        var DicKey = "\(type)_\(key)"
        if secondaryType != ""{
            DicKey += secondaryType
        }
        if level != nil {
            DicKey += "\(level!)"
        }
        DicKey += "_type"
        
        if let priceType = self.priceList[DicKey]{
            if priceType == 1{
                return CurrencyType.coin
            }   else if priceType == 2{
                return CurrencyType.gem
            }
        }
        return CurrencyType.gem
    }
    
    func purchase(item: StoreItem, vc: UIViewController){
        
        let powerUp = MinesLover.getPowerUpBy(storeItemName: item.productCategory)
        
    
        if !item.ifLocked{
            if !item.soldOutFlag{
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
                    case .currency:
                        if item.productCategory == .coin{
                            MinesLover.Coins += item.numberOfProducts
                        }
                        if item.productCategory == .gem{
                            MinesLover.Gems += item.numberOfProducts
                        }
                    }
                    item.getCurrentData()
                    //MinesLover.record.saveRecord()
                }   else    {
                    vc.notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                vc.notifyUser("CAUTION", message: "5 is Enough, Man!")
            }
            
        }   else    {
            vc.notifyUser("CAUTION", message: "Please Unlock Mine X-Ray First!")
        }
            
    }
    
    func virtualSales(price: Int, currencyType: CurrencyType) -> Bool{
        switch(currencyType){
        case .coin:
            let newBlance = MinesLover.Coins - price
            if(newBlance >= 0){
                MinesLover.Coins -= price
                //MinesLover.record.saveRecord()
                return true
            }   else{
                return false;
            }
        case .gem:
            let newBlance = MinesLover.Gems - price
            if(newBlance >= 0){
                MinesLover.Gems -= price
                //MinesLover.record.saveRecord()
                return true
            }   else{
                return false;
            }
        default:
            return false
            
        }
        return false
    }
}
