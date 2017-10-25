//
//  StoreCurrencyViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import StoreKit

class StoreCurrencyViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currencyTableView: UITableView!
    var itemInfo: IndicatorInfo = "Passes"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identfier = "storeTbCell"
        let cell:storeElementTableViewCell = self.currencyTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
        cell.storeElementTitleConstraintsTop.constant = 35.0
        cell.storeElementBarContainer.isHidden = true;
        cell.storeElementButton.tag = indexPath.row
        cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromCurrencyTableView(sender:)), for: UIControlEvents.touchUpInside)
        cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(self.storePriceButtonTitleOffset), 0, 0)
        cell.storeElementLock.isHidden = true;
        cell.storeElementView.alpha = 1.0
        switch (indexPath.row){
        case 3:
            cell.storeElementTitle.text = "5 Gems"
            cell.storeElementImage.image = UIImage(named: "gem")
            cell.storeElementButton.setTitle("$0.99", for: .normal)
            cell.storeElementDescription.text = "5 Gems for $0.99";
            cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
            cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            break
        case 4:
            cell.storeElementTitle.text = "15 Gems"
            cell.storeElementImage.image = UIImage(named: "gem")
            cell.storeElementButton.setTitle("$1.99", for: .normal)
            cell.storeElementDescription.text = "15 Gems for $1.99";
            cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
            cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            break;
        default:
            if(indexPath.row < 3){
                cell.storeElementTitle.text = "\(String(describing: self.priceList["currency_\(indexPath.row + 1)_product"]!)) Coins"
                
                switch (self.priceList["currency_\(indexPath.row + 1)_price_type"]!){
                case 1:
                    cell.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                    break;
                case 2:
                    cell.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                    break;
                default:
                    break;
                }
                cell.storeElementImage.image = UIImage(named: "moneyBag_\(indexPath.row)")
                cell.storeElementButton.setTitle("\(self.priceList["currency_\(indexPath.row + 1)_price"]!)", for: .normal)
                cell.storeElementDescription.text = "Buy \(String(describing: self.priceList["currency_\(indexPath.row + 1)_product"]!)) coins with \(self.priceList["currency_\(indexPath.row + 1)_price"]!) gems"
                
            }
            break;
        }
        return cell
    }
    func buttonClickedFromCurrencyTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        switch (buttonRow){
        case 3:
            self.purchase(purchaseGem5Suffix)
            break;
        case 4:
            self.purchase(purchaseGem15Suffix)
            break;
        default:
            if(buttonRow < 3){
                let price = self.priceList["currency_\(buttonRow + 1)_price"]!
                let priceType = self.priceList["currency_\(buttonRow + 1)_price_type"]!
                let addPrice = (-1) * (self.priceList["currency_\(buttonRow + 1)_product"]!)
                let addPriceType = self.priceList["currency_\(buttonRow + 1)_product_type"]!
                if(deductFromMoney(price: price, type: priceType)){
                    print("Adding Coins \(addPrice)");
                    _ = deductFromMoney(price: addPrice, type: addPriceType)
                    saveRecord()
                }   else    {
                    self.notifyUser("CAUTION", message: "Insufficient Fund")
                }
            }
            break;
        }
        
        currencyTableView.reloadData()
        
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
    
    //In-App Purchase
    
    
    func getInfo(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([appBundleId + ".purchase." + purchase.rawValue]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    func purchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(appBundleId + ".purchase." + purchase.rawValue, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production)
        let password = "your-shared-secret"
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: password, completion: completion)
    }
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                
                let productId = self.appBundleId + ".purchase." + purchase.rawValue
                
                switch purchase {
                case .autoRenewablePurchase:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        type: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt,
                        validUntil: Date()
                    )
                    self.showAlert(self.alertForVerifySubscription(purchaseResult))
                case .nonRenewingPurchase:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        type: .nonRenewing(validDuration: 60),
                        productId: productId,
                        inReceipt: receipt,
                        validUntil: Date()
                    )
                    self.showAlert(self.alertForVerifySubscription(purchaseResult))
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt
                    )
                    self.showAlert(self.alertForVerifyPurchase(purchaseResult))
                }
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }


}
