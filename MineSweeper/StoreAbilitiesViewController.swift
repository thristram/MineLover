//
//  StoreAbilitiesViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreAbilitiesViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var abilitiesTableView: UITableView!
    var itemInfo: IndicatorInfo = "Passes"; 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.abilitiesTableView.delegate = self
        self.abilitiesTableView.dataSource = self
        self.abilitiesTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identfier = "storeTbCell"
        let cell:storeElementTableViewCell = self.abilitiesTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
        
        cell.storeElementButton.tag = indexPath.row
        cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromAblititiesTableView(sender:)), for: UIControlEvents.touchUpInside)
        
        
        var remaining = 0
        var name = ""
        var secondaryType = "lv"
        cell.storeElementLock.isHidden = true;
        cell.storeElementView.alpha = 1.0
        
        
        
        if indexPath.row < 3{
            if let pu = MinesLover.powerUps[PowerUpType.getBy(rawValue: indexPath.row)]{
                cell.storeElementTitle.text = pu.getStoreUpgradeText()
                cell.storeElementDescription.text = pu.storeDescription
                cell.storeElementImage.image = UIImage(named: "\(pu.storeShortCode)_lv");
                name = pu.storeShortCode
                remaining = pu.currentLevel
                if(pu.currentLevel < 1) {
                    cell.storeElementView.alpha = 0.5
                    cell.storeElementLock.isHidden = false;
                }
            }
        }
        
        if let pu = MinesLover.powerUps[.crazySweeper]{
            if indexPath.row == 3{
                cell.storeElementTitle.text = pu.getStoreSecondaryUpgradeText()
                cell.storeElementDescription.text = "Expand Crazy Click Time"
                cell.storeElementImage.image = UIImage(named: "crazy_time");
                remaining =  pu.currentSecondaryLevel
                secondaryType = "time";
                name = pu.storeShortCode
                if(pu.currentLevel < 1) {
                    cell.storeElementView.alpha = 0.5
                    cell.storeElementLock.isHidden = false;
                }
            }
        }
        
        
       
        if(remaining >= 5){
            cell.storeElementButton.setTitle("SOLD OUT", for: .normal)
            cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
            cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }   else{
            cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(MinesLover.UIElements["storePriceButtonTitleOffset"]!), 0, 0)
            switch (MinesLover.store.getPriceType(type: "Ability", key: name, secondaryType: secondaryType, level: (remaining + 1))){
            case .coin:
                cell.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                break;
            case .gem:
                cell.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                break;
            default:
                break;
            }
            let price = MinesLover.store.getPrice(type: "Ability", key: name, secondaryType: secondaryType, level: (remaining + 1))
            cell.storeElementButton.setTitle("\(price)", for: .normal)
            
        }
        
        cell.displayProgressBar(number: remaining)
        
        
        
        return cell
    }
    
    func buttonClickedFromAblititiesTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        switch (buttonRow){
        case 0:
            if((powerUp1["level"])! < 5){
                let oldValue = self.powerUp1["level"]!
                let priceName = "Ability_XRay_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp1["level"] = oldValue + 1;
                    if(oldValue == 0){
                        self.notifyUser("Congratulations", message: "You've Unlock Mine X-Ray! We'll Also Reward You \(self.complementaryPassesAfterUnlock) Complementary Passes, Check it Out!")
                        self.powerUp1["remaining"] = self.powerUp1["remaining"]! + self.complementaryPassesAfterUnlock
                        self.updatePowerUpText()
                        self.switchToStorePasses()
                    }
                    
                    saveRecord()
                }   else    {
                    self.notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                self.notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }
            
            break;
        case 1:
            
            if((powerUp2["level"])! < 5){
                let oldValue = self.powerUp2["level"]!
                let priceName = "Ability_Sweeper_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp2["level"] = oldValue + 1;
                    if(oldValue == 0){
                        self.notifyUser("Congratulations", message: "You've Unlock Crazy Sweeper! We'll Also Reward You \(self.complementaryPassesAfterUnlock) Complementary Passes, Check it Out!")
                        self.powerUp2["remaining"] = self.powerUp2["remaining"]! + self.complementaryPassesAfterUnlock
                        self.updatePowerUpText()
                        self.switchToStorePasses()
                    }
                    saveRecord()
                }   else    {
                    self.notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                self.notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }
            
            break;
        case 2:
            if((powerUp2["level"])! > 0){
                if((powerUp2["time"])! < 5){
                    let oldValue = self.powerUp2["time"]!
                    let priceName = "Ability_Sweeper_time_\(oldValue + 1)"
                    let price = self.priceList["\(priceName)"]!
                    let priceType = self.priceList["\(priceName)_type"]!
                    
                    if(deductFromMoney(price: price, type: priceType)){
                        self.powerUp2["time"] = oldValue + 1;
                        self.updatePowerUpText()
                        saveRecord()
                    }   else    {
                        self.notifyUser("CAUTION", message: "Insufficient Fund")
                    }
                    
                }   else{
                    self.notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
                }
                
            }   else   {
                self.notifyUser("CAUTION", message: "Please Unlock Crazy Sweeper First!")
            }
            
            break;
        case 3:
            if((powerUp3["level"])! < 5){
                let oldValue = self.powerUp3["level"]!
                let priceName = "Ability_Corrector_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp3["level"] = oldValue + 1;
                    if(oldValue == 0){
                        self.notifyUser("Congratulations", message: "You've Unlock Miss-Sweep Proof! We'll Also Reward You \(self.complementaryPassesAfterUnlock) Complementary Passes, Check it Out!")
                        self.powerUp3["remaining"] = self.powerUp3["remaining"]! + self.complementaryPassesAfterUnlock
                        self.updatePowerUpText()
                        self.switchToStorePasses()
                        
                    }
                    saveRecord()
                }   else    {
                    self.notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                self.notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }
            break;
            
        default:
            break;
        }
        
        
        abilitiesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
