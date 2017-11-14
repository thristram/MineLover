//
//  StorePassesViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StorePassesViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var itemInfo: IndicatorInfo = "Passes"
    var items: [StoreItem] = []
    let reuseIdentifier = "storeTbCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = MinesLover.store.getProductBy(type: [.passes])
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView!.register(UINib(nibName: "storeElementItem", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch MinesLover.screenSize(){
        case "7":
            return CGSize(width: 175, height: 270)
        case "7+":
            return CGSize(width: 195, height: 300)
        default:
            return CGSize(width: 175, height: 270)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! storeElementCollectionViewCell
    
        let item = self.items[indexPath.item]
        //cell.storeElementButton.tag = indexPath.item
        //cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromcollectionView(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.lockItem(ifLock: item.ifLocked)
        cell.storeElementTitle.text = item.displayName
        cell.storeElementDescription.text = item.description
        cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_pass");
        cell.displayProgressBar(number: item.productsLeft)
        cell.displayPrice(item: item)
    

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Row: \(indexPath.item) Selected")
        let buttonRow = indexPath.item
        self.buttonActions(index: buttonRow)
    }
    
    func buttonClickedFromcollectionView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        self.buttonActions(index: buttonRow)
        
    }
    
    func buttonActions(index: Int){
        
        MinesLover.store.purchase(item: self.items[index], vc: self)
        self.collectionView.reloadData()
        
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
