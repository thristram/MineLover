//
//  StorePassesViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StorePassesViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var passesTableView: UITableView!
    
    var itemInfo: IndicatorInfo = "Passes"
    var items: [StoreItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = MinesLover.store.getProductBy(type: [.passes])
        self.passesTableView.delegate = self
        self.passesTableView.dataSource = self
        self.passesTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identfier = "storeTbCell"
        let cell:storeElementTableViewCell = self.passesTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
        let item = self.items[indexPath.row]
        cell.storeElementButton.tag = indexPath.row
        cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromPassesTableView(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.lockItem(ifLock: item.ifLocked)
        cell.storeElementTitle.text = item.displayName
        cell.storeElementDescription.text = item.description
        cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_pass");
        cell.displayProgressBar(number: item.productsLeft)
        cell.displayPrice(item: item)
    

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row: \(indexPath.row) Selected")
        self.passesTableView.deselectRow(at: indexPath, animated: true)

    }
    
    func buttonClickedFromPassesTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        self.buttonActions(index: buttonRow)
        
    }
    
    func buttonActions(index: Int){
        
        MinesLover.store.purchase(item: self.items[index], vc: self)
        self.passesTableView.reloadData()
        
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
