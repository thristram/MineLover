//
//  StoreAbilitiesViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreAbilitiesViewController: UIViewController, IndicatorInfoProvider,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var collectionView: UICollectionView!
    var itemInfo: IndicatorInfo = "Passes"
    var itemAbilities: [StoreItem] = []
    var itemPasses: [StoreItem] = []
    var itemCurrency: [StoreItem] = []
    var itemDeals: [StoreItem] = []
    let reuseIdentifier = "newStoreCollectionCell"
    let reuseIdentifierSmall = "newStoreCollectionCellSmall"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemAbilities = MinesLover.store.getProductBy(type: [.abilitiesLevel, .abilitiesTime])
        self.itemPasses = MinesLover.store.getProductBy(type: [.passes])
        self.itemCurrency = MinesLover.store.getProductBy(type: [.currency])
        for item in MinesLover.store.getProductBy(type: [.deal]){
            if !item.soldOutFlag{
                self.itemDeals.append(item)
            }
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "newStoreElementItem", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "newStoreSmallElementCollectionCell", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifierSmall)
        self.collectionView!.register(UINib(nibName: "StoreSectionTitleView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "storeSectionTitle")
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
        case 3:
            return CGSize(width: (UIScreen.main.bounds.width - 48) / 3, height: 70)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 54)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize{
        switch section{
        case 3:
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 54)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "storeSectionTitle", for: indexPath as IndexPath) as! StoreSectionTitleCollectionReusableView
        switch indexPath.section{
        case 0:
            headerView.sectionTitle.text = "ABILITIES"
            break
        case 1:
            headerView.sectionTitle.text = "PASSES"
            break
        case 2:
            headerView.sectionTitle.text = "CURRENCY"
            break
        default:
            break
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.itemAbilities.count
        case 1:
            return self.itemPasses.count
        case 2:
            return self.itemCurrency.count
        case 3:
            return self.itemDeals.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! newStoreElementCollectionViewCell
            cell.storeElementLock.isHidden = true
            let item = self.itemAbilities[indexPath.row]
            cell.storeElementTitle.text = item.getName()
            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_pass_solid")
            cell.displayPrice(item: item)
            cell.storeElementView.backgroundColor = UIColor.seraphDarkPurple
            cell.storeElementPriceContainer.backgroundColor = UIColor.seraphLightPurple
            cell.setSingleLine()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! newStoreElementCollectionViewCell
            cell.storeElementLock.isHidden = true
            let item = self.itemPasses[indexPath.row]
            switch item.productCategory{
            case .crazySweeper:
                cell.storeElementTitle.text = "CRAZY PASS"
                break
            case .protector:
                cell.storeElementTitle.text = "PROTECTOR PASS"
                break
            case .xray:
                cell.storeElementTitle.text = "X-RAY PASS"
                break
            default:
                break
            }

            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_pass_solid")
            cell.displayPrice(item: item)
            cell.storeElementView.backgroundColor = UIColor.seraphDarkBlue
            cell.storeElementPriceContainer.backgroundColor = UIColor(hex: 0x2069CF)
            cell.setSingleLine()
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! newStoreElementCollectionViewCell
            let item = self.itemCurrency[indexPath.item]
            cell.storeElementTitle.text = item.displayName.uppercased()
            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_currency");
            cell.setSingleLine()
            cell.displayPrice(item: item)
            cell.storeElementLock.isHidden = true
            return cell
        case 3:
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
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath as IndexPath) as! newStoreElementCollectionViewCell
            return cell

        }

        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Row: \(indexPath.item) Selected")
        let index = indexPath.item
        switch indexPath.section{
        case 0:
            
            MinesLover.store.purchase(item: self.itemAbilities[index], vc: self)
            self.collectionView.reloadData()
            self.itemAbilities = []
            self.itemAbilities = MinesLover.store.getProductBy(type: [.abilitiesLevel, .abilitiesTime])
            break
        case 1:
            MinesLover.store.purchase(item: self.itemPasses[index], vc: self)
            self.collectionView.reloadData()
            break
        case 2:
            MinesLover.store.purchase(item: self.itemCurrency[index], vc: self)
            self.collectionView.reloadData()
            break
        case 3:
            let cell = self.collectionView.cellForItem(at: indexPath) as! newStoreSmallElementCollectionViewCell
            let storeItem = self.itemDeals[index]
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
