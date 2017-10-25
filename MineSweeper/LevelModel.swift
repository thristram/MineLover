//
//  LevelModel.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation


class LevelMap{
    
    var width: Int
    var height: Int
    var mines: Int
    var scale: Double
    var scaleable: Bool
    var maxScale: Double
    var minScale: Double
    var marginTop: Double
    var marginLeft: Double
    var tdWidth: Int
    var tdHeight: Int
    var divWidth: Int
    var divHeight: Int
    var iconFontSize: Int
    var fontSize: Int
    
    init(width: Int ,  height: Int ,  mines: Int ,  scale: Double ,  scaleable: Bool ,  maxScale: Double ,  minScale: Double ,  marginTop: Double ,  marginLeft: Double ,  tdWidth: Int ,  tdHeight: Int ,  divWidth: Int ,  divHeight: Int ,  iconFontSize: Int ,  fontSize: Int){
        self.width = width
        self.height = height
        self.mines = mines
        self.scale = scale
        self.scaleable = scaleable
        self.maxScale = maxScale
        self.minScale = minScale
        self.marginTop = marginTop
        self.marginLeft = marginLeft
        self.tdWidth = tdWidth
        self.tdHeight = tdHeight
        self.divWidth = divWidth
        self.divHeight = divHeight
        self.iconFontSize = iconFontSize
        self.fontSize = fontSize
    }
    func getScaleable() -> String{
        if self.scaleable {
            return "yes"
        }   else{
            return "no"
        }
    }
    func constructMapJS(map: String = "") -> String{
        let JScript: String
        if map == ""{
            JScript = "resetGame( '\(self.width)', '\(self.height)', '\(self.mines)', '\(self.scale)', '\(self.getScaleable())', '\(self.maxScale)', '\(self.minScale)', '\(self.marginTop)', '\(self.marginLeft)', '\(self.tdWidth)', '\(self.tdHeight)', '\(self.divWidth)', '\(self.divHeight)', '\(self.fontSize)%', '\(self.iconFontSize)%')"
        }   else    {
            JScript = "resetGame( '\(self.width)', '\(self.height)', '\(self.mines)', '\(self.scale)', '\(self.getScaleable())', '\(self.maxScale)', '\(self.minScale)', '\(self.marginTop)', '\(self.marginLeft)', '\(self.tdWidth)', '\(self.tdHeight)', '\(self.divWidth)', '\(self.divHeight)', '\(self.fontSize)%', '\(self.iconFontSize)%', '\(map)')"
        }
        
        return JScript
    }
    
}

class MLevel: LevelMap{
    var level: Int
    var levelName: String
    var record: LevelRecord
    
    init(level: Int, levelName: String, width: Int ,  height: Int ,  mines: Int ,  scale: Double ,  scaleable: Bool = true,  maxScale: Double = 1.0,  minScale: Double = 1.0,  marginTop: Double ,  marginLeft: Double ,  tdWidth: Int = 32,  tdHeight: Int  = 32,  divWidth: Int  = 30,  divHeight: Int  = 30,  iconFontSize: Int  = 150,  fontSize: Int = 100){
        self.level = level
        self.levelName = levelName
        self.record = LevelRecord()
        super.init(width: width, height: height, mines: mines, scale: scale, scaleable: scaleable, maxScale: maxScale, minScale: minScale, marginTop: marginTop, marginLeft: marginLeft, tdWidth: tdWidth, tdHeight: tdHeight, divWidth: divWidth, divHeight: divHeight, iconFontSize: iconFontSize, fontSize: fontSize)
        
    }
}
