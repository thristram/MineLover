//
//  MineFlagsModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/15/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation

class MineFlag{
    var iconName: String
    var iconPrice: Int
    var iconPriceUnit: CurrencyType
    
    init(iconName: String, iconPrice: Int, iconPriceUnit: CurrencyType){
        self.iconName = iconName
        self.iconPrice = iconPrice
        self.iconPriceUnit = iconPriceUnit
    }
}
