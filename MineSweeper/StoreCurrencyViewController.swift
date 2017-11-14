//
//  StoreCurrencyViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class StoreCurrencyViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var itemInfo: IndicatorInfo = "Currency"
    var items: [StoreItem] = []
    var itemDeals: [StoreItem] = []
    let reuseIdentifier = "newStoreCollectionCell"
    let reuseIdentifierSmall = "newStoreCollectionCellSmall"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = MinesLover.store.getProductBy(type: [.currency])
        for item in MinesLover.store.getProductBy(type: [.deal]){
            if !item.soldOutFlag{
                self.itemDeals.append(item)
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "newStoreElementItem", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "newStoreSmallElementCollectionCell", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifierSmall)
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch MinesLover.screenSize(){
            
        default:
            switch indexPath.section{
            case 0:
                return CGSize(width: UIScreen.main.bounds.width - 32, height: 54)
            case 1:
                return CGSize(width: (UIScreen.main.bounds.width - 48) / 3, height: 70)
            default:
                return CGSize(width: UIScreen.main.bounds.width - 32, height: 54)
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.items.count
        case 1:
            return self.itemDeals.count
        default:
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! newStoreElementCollectionViewCell
            let item = self.items[indexPath.item]
            cell.storeElementTitle.text = item.displayName.uppercased()
            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_currency");
            cell.setSingleLine()
            cell.displayPrice(item: item)
            cell.storeElementLock.isHidden = true
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifierSmall, for: indexPath as IndexPath) as! newStoreSmallElementCollectionViewCell
            let item = self.itemDeals[indexPath.item]
            cell.storeElementTitle.text = "\(item.numberOfProducts)"
            cell.storeElementView.backgroundColor = UIColor(hex: 0xFF3464)
            switch item.productCategory{
            case .coin:
                cell.storeElementImage.image = UIImage(named: "coin")
                break
            case .gem:
                cell.storeElementImage.image = UIImage(named: "gem")
                break
            default:
                break
            }
            cell.storeCoverView.isHidden = false
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            print("Row: \(indexPath.item) Selected")
            let index = indexPath.item
            MinesLover.store.purchase(item: self.items[index], vc: self)
            self.collectionView.reloadData()
        case 1:
            let cell = self.collectionView.cellForItem(at: indexPath) as! newStoreSmallElementCollectionViewCell
            print("Row: \(indexPath.item) Selected")
            let buttonRow = indexPath.item
            let storeItem = self.itemDeals[buttonRow]
            cell.storeCoverView.isHidden = true
            cell.storeElementView.isHidden = false
            cell.storeElementView.backgroundColor = UIColor(hex: 0x1B1B1B)
            if !storeItem.soldOutFlag{
                MinesLover.store.purchase(item: storeItem, vc: self)
            }
            
            break
        default:
            break
        }
        
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
