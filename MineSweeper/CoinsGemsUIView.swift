//
//  CoinsGemsUIView.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/25/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class CoinsGemsUIView: UIView {

    var currentCoin: Int = 0
    var currentGem: Int = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var currencyView: UIView!
    @IBOutlet weak var gem: EFCountingLabel!
    @IBOutlet weak var coin: EFCountingLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewDidInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDidInit()
    }

    func viewDidInit(){
        Bundle.main.loadNibNamed("CoinsGemsView", owner: self, options: nil)
        self.addSubview(currencyView)
        currencyView.frame = self.bounds
        currencyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.currentGem = MinesLover.Gems
        self.currentCoin = MinesLover.Coins
        
        self.coin.format = "%d"
        self.gem.format = "%d"
        self.coin.animationDuration = TimeInterval(0)
        self.gem.animationDuration = TimeInterval(0)
        self.coin.countFromCurrentValueTo(CGFloat(MinesLover.Coins))
        self.gem.countFromCurrentValueTo(CGFloat(MinesLover.Gems))
        self.coin.animationDuration = TimeInterval(1)
        self.gem.animationDuration = TimeInterval(0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateGem(_:)), name: NSNotification.Name(rawValue: "updateGems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoin(_:)), name: NSNotification.Name(rawValue: "updateCoins"), object: nil)
    }
    
    func updateGem(_ notification: NSNotification){
        print("")
//        self.gem.countFromCurrentValueTo(CGFloat(MinesLover.Gems))
        self.gem.countFrom(CGFloat(self.currentGem), to: CGFloat(MinesLover.Gems))
        self.currentGem = MinesLover.Gems
    }
    
    func updateCoin(_ notification: NSNotification){
        print("GET NEW COIN")
//        self.coin.countFromCurrentValueTo(CGFloat(MinesLover.Coins))
        self.coin.countFrom(CGFloat(self.currentCoin), to: CGFloat(MinesLover.Coins))
        self.currentCoin = MinesLover.Coins
    }
    
}
