//
//  StoreDealsViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreDealsViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dealsTableView: UITableView!
    var itemInfo: IndicatorInfo = "Passes"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dealsTableView.delegate = self
        self.dealsTableView.dataSource = self
        
        self.dealsTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identfier = "storeTbCell"
        let cell:storeElementTableViewCell = self.dealsTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
        cell.storeElementTitleConstraintsTop.constant = 35.0
        cell.storeElementBarContainer.isHidden = true;
        cell.storeElementButton.tag = indexPath.row
        cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromDealsTableView(sender:)), for: UIControlEvents.touchUpInside)
        cell.storeElementLock.isHidden = true;
        cell.storeElementView.alpha = 1.0
        
        
        if let dc = MinesLover.dailyCheckIns[DailyCheckInType.getBy(rawValue: (indexPath.row + 1))]{
            cell.storeElementImage.image = UIImage(named: "gift_\(dc.name.lowercased())")
            cell.storeElementTitle.text = "Gift \(dc.name) By TT"
            cell.storeElementDescription.text = "Free \(dc.name.lowercased()) from some loves you"
            cell.storeElementButton.setTitle("FREE", for: .normal)
            cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
            cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            let currentTimeStamp = Int(MinesLover.publicMethods.getTimestamp())!
            let timeIntival = currentTimeStamp - dc.lastClaim
            
            if(timeIntival < dc.claimIntval){
                cell.storeElementButton.setTitle("SOLD OUT", for: .normal)
            }
            
        }
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dealsTableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row) Selected")
        if let dc = MinesLover.dailyCheckIns[DailyCheckInType.getBy(rawValue: (indexPath.row + 1))]{
            var timeIntivalString = "tomorrow"
            var currencyType: CurrencyType = .gem
            switch indexPath.row {
            case 1:
                currencyType = .coin
            case 2:
                timeIntivalString = "next week"
                break
            default:
                break
            }
            
            let currentTimeStamp = Int(MinesLover.publicMethods.getTimestamp())!
            let timeIntival = currentTimeStamp - dc.lastClaim
            
            if(timeIntival > dc.claimIntval){
                _ = MinesLover.store.virtualSales(price: (-1) * dc.amount, currencyType: currencyType)
            }   else{
                self.notifyUser("CAUTION", message: "Get more \(dc.name) \(timeIntivalString)!")
            }
        }
    }
    
    func buttonClickedFromDealsTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        
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
