//
//  StoreMainViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StoreMainViewController: ButtonBarPagerTabStripViewController  {

    ////////////////////////////////
    /////////STORE ELEMENTS/////////
    ////////////////////////////////
    
    @IBOutlet weak var coinStoreView: EFCountingLabel!
    @IBOutlet weak var gemStoreView: EFCountingLabel!
    @IBOutlet weak var storeView: UIView!
    
    

    
    var isReload = false
    
    @IBAction func hideView(_ sender: Any) {
        self.hideStoreView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settings.style.buttonBarItemIfEnlargeSelectedBarFont = false
        self.buttonBarView.frame.origin = CGPoint(x: self.buttonBarView.frame.origin.x, y: 74)
        self.coinStoreView.format = "%d"
        self.gemStoreView.format = "%d"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coinStoreView.text = "\(MinesLover.Coins)";
        self.gemStoreView.text = "\(MinesLover.Gems)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StorePasses") as! StorePassesViewController
        child_1.itemInfo.title = "Passes".localized();
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreDeals") as! StoreDealsViewController
        child_2.itemInfo.title = "Deals".localized();
        
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StorePasses") as! StorePassesViewController
        child_3.itemInfo.title = "Lights".localized();
        
        guard isReload else {
            return [child_1, child_2, child_3]
        }
        
        var childViewControllers = [child_1, child_2, child_3]
        
        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                swap(&childViewControllers[index], &childViewControllers[n])
            }
        }
        let nItems = 1 + (arc4random() % 5)
        return Array(childViewControllers.prefix(Int(nItems)))
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
    func hideStoreView(){
        self.dismiss(animated: false, completion: nil)
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
