//
//  StoreMainViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
//import XLPagerTabStrip

//class StoreMainViewController: ButtonBarPagerTabStripViewController, MIBlurPopupDelegate  {
class StoreMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  MIBlurPopupDelegate  {
    ////////////////////////////////
    /////////STORE ELEMENTS/////////
    ////////////////////////////////
    
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
//    var itemInfo: IndicatorInfo = "Passes"
    var itemAbilities: [StoreItem] = []
    var itemPasses: [StoreItem] = []
    var itemCurrency: [StoreItem] = []
    var itemDeals: [StoreItem] = []
    let reuseIdentifier = "newStoreCollectionCell"
    let reuseIdentifierSmall = "newStoreCollectionCellSmall"
    
    
    var popupView: UIView {
        return self.collectionView
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 0.8
    }
    var animationDuration: TimeInterval {
        return TimeInterval(1)
    }
    
    
    var storeToShow: StoreItemType = .abilitiesLevel
    var isReload = false
    
    @IBAction func hideView(_ sender: Any) {
        self.hideStoreView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        self.backButton.layer.zPosition = 100000
        
        self.itemAbilities = MinesLover.store.getProductBy(type: [.abilitiesLevel, .abilitiesTime])
        self.itemPasses = MinesLover.store.getProductBy(type: [.passes])
        self.itemCurrency = MinesLover.store.getProductBy(type: [.currency])
        for item in MinesLover.store.getProductBy(type: [.deal]){
            if !item.soldOutFlag{
                self.itemDeals.append(item)
            }
        }
        self.collectionView!.register(UINib(nibName: "newStoreElementItem", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "newStoreSmallElementCollectionCell", bundle: nil), forCellWithReuseIdentifier: self.reuseIdentifierSmall)
        self.collectionView!.register(UINib(nibName: "StoreSectionTitleView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "storeSectionTitle")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        self.settings.style.buttonBarItemIfEnlargeSelectedBarFont = false
//        self.buttonBarView.frame.origin = CGPoint(x: self.buttonBarView.frame.origin.x, y: CGFloat(MinesLover.UIElements["storePargerBarTop"]!))
        
        // Replacing with your dimensions
        //self.currencyView.addSubview(CoinsGemsUIView(frame: self.currencyView.frame))
        // Do any additional setup after loading the view.
//        switch self.storeToShow{
//        case .abilitiesLevel:
//            self.moveToViewController(at: 0, animated: false)
//            break
//        case .abilitiesTime:
//            self.moveToViewController(at: 0, animated: false)
//            break
//        case .currency:
//            self.moveToViewController(at: 1, animated: false)
//            break
//        case .passes:
//            self.moveToViewController(at: 2, animated: false)
//            break
//        case .deal:
//            self.moveToViewController(at: 3, animated: false)
//            break
//
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            headerView.sectionTitle.text = "UPGRADE POWER-UPS"
            break
        case 1:
            headerView.sectionTitle.text = "POWER-UP PASSES"
            break
        case 2:
            headerView.sectionTitle.text = "COINS & GEMS"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! newStoreElementCollectionViewCell
        let index = indexPath.item
        let section = indexPath.section
        cell.storeElementTitle.text = "\(section)-\(index)"
        
        switch section{
        case 0:

            
            let item = self.itemAbilities[index]

            cell.storeView.backgroundColor = UIColor.seraphDarkPurple
            cell.storeElementPriceContainer.backgroundColor = UIColor.seraphLightPurple

            cell.storeElementTitle.text = item.getName()
            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_pass_solid")
            cell.displayPrice(item: item)
            if item.ifLocked{
                cell.storeItemStatus(status: .locked)
            }   else if item.soldOutFlag {
                cell.storeItemStatus(status: .fullyUpgraded)
            }   else    {
                cell.storeItemStatus(status: .none)
            }
            cell.setSingleLine()
            return cell
        case 1:

            let item = self.itemPasses[index]

            cell.storeView.backgroundColor = UIColor.seraphDarkBlue
            cell.storeElementPriceContainer.backgroundColor = UIColor(hex: 0x2069CF)

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
            if item.ifLocked{
                cell.storeItemStatus(status: .locked)
            }   else if item.soldOutFlag {
                cell.storeItemStatus(status: .soldOut)
            }   else    {
                cell.storeItemStatus(status: .none)
            }
            cell.setSingleLine()
            return cell
        case 2:

            let item = self.itemCurrency[index]
            cell.storeItemStatus(status: .none)
            cell.storeView.backgroundColor = UIColor(hex:0xf19736)
            cell.storeElementPriceContainer.backgroundColor = UIColor(hex: 0xE07E2B)

            cell.storeElementTitle.text = item.displayName.uppercased()
            cell.storeElementImage.image = UIImage(named: "\(item.shortCode)_currency")
            cell.setSingleLine()
            cell.displayPrice(item: item)

            return cell
        case 3:
            let smCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifierSmall, for: indexPath as IndexPath) as! newStoreSmallElementCollectionViewCell
            let item = self.itemDeals[index]


            smCell.storeElementTitle.text = "\(item.numberOfProducts)"
            smCell.storeElementView.backgroundColor = UIColor(hex: 0xFF3464)
            switch item.productCategory{
            case .coin:
                smCell.storeElementImage.image = UIImage(named: "coin")
                break
            case .gem:
                smCell.storeElementImage.image = UIImage(named: "gem")
                break
            default:
                break
            }
            smCell.storeCoverView.isHidden = false
            return smCell
        default:

            return cell

        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Section: \(indexPath.section) Row: \(indexPath.item) Selected")
        let index = indexPath.item
        switch indexPath.section{
        case 0:

            MinesLover.store.purchase(item: self.itemAbilities[index], vc: self)
            self.reloadStoreData()
            break
        case 1:
            MinesLover.store.purchase(item: self.itemPasses[index], vc: self)
            self.reloadStoreData()

            break
        case 2:
            MinesLover.store.purchase(item: self.itemCurrency[index], vc: self)
            self.reloadStoreData()

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
    
    
    
    
//    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//
//        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StorePasses") as! StorePassesViewController
//        child_1.itemInfo.title = "Passes".localized();
//
//        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreCurrency") as! StoreCurrencyViewController
//        child_2.itemInfo.title = "Currency".localized();
//
////        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreDeals") as! StoreDealsViewController
////        child_3.itemInfo.title = "Deals".localized();
//
//        let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreAbilities") as! StoreAbilitiesViewController
//        child_4.itemInfo.title = "Abilities".localized();
//
//        guard isReload else {
//            return [child_4, child_2, child_1]
//        }
//
//        var childViewControllers = [child_4, child_2, child_1]
//
//        for index in childViewControllers.indices {
//            let nElements = childViewControllers.count - index
//            let n = (Int(arc4random()) % nElements) + index
//            if n != index {
//                swap(&childViewControllers[index], &childViewControllers[n])
//            }
//        }
//        let nItems = 1 + (arc4random() % 5)
//        return Array(childViewControllers.prefix(Int(nItems)))
//    }
//
//    override func reloadPagerTabStripView() {
//        isReload = true
//        if arc4random() % 2 == 0 {
//            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
//        } else {
//            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
//        }
//        super.reloadPagerTabStripView()
//    }
//
    func hideStoreView(){
        self.dismiss(animated: true, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "storeDidClose"), object: nil, userInfo: [:])
        })
    }
    func reloadStoreData(){
        self.itemAbilities = MinesLover.store.getProductBy(type: [.abilitiesLevel, .abilitiesTime])
        self.itemPasses = MinesLover.store.getProductBy(type: [.passes])
        self.itemCurrency = MinesLover.store.getProductBy(type: [.currency])
        self.collectionView.reloadData()
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
