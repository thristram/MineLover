//
//  PowerUpViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class PowerUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    var selectedStoreType: StoreItemType = .abilitiesLevel
    
    @IBAction func closePowerUpView(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
    }
    let reuseIdentifier = "powerUpCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        self.collectionView!.register(UINib(nibName: "PowerCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(self.storeDidClose(_:)), name: NSNotification.Name(rawValue: "storeDidClose"), object: nil)
        // Do any additional setup after loading the view.
    }
    func storeDidClose(_ notification: NSNotification){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch MinesLover.screenSize(){
        case "7":
            return CGSize(width: 175, height: 290)
        case "7+":
            return CGSize(width: 195, height: 320)
        default:
            return CGSize(width: 175, height: 290)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PowerUpCollectionViewCell
        let index = indexPath.item
        if indexPath.item < 3 {
            
            cell.powerUpProgressBar.isHidden = false
            let powerUp = MinesLover.powerUps[PowerUpType.getBy(rawValue: index + 1)]!
            cell.constructCell(powerUp: powerUp)
        }   else if index == 3 {
            cell.powerUpImage.image = UIImage(named: "shoppingCart")
            cell.powerUpTitle.text = "Store"
            cell.powerUpDescription.text = "Buy passes, coins and upgrade power ups"
            cell.powerUpStatus.isHidden = true
            cell.powerUpProgressBar.isHidden = true
            cell.powerUpImageVerticalAlign.constant = -41
            cell.powerUpLock.isHidden = true
            cell.powerUpContentView.alpha = 1
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if index == 3{
            self.showStore(storeType: .passes)
        }   else    {
            let powerUp = MinesLover.powerUps[PowerUpType.getBy(rawValue: index + 1)]!
            if powerUp.currentLevel == 0 {
                self.showStore(storeType: .abilitiesLevel)
            }   else if powerUp.remainingPass < 1 {
                self.showStore(storeType: .passes)
            }   else if MinesLover.powerUpMode != .none{
                self.notifyUser("CAUTION", message: "Other Power-Ups in Use")
            }   else if powerUp.powerUpUsed {
                self.notifyUser("CAUTION", message: "This Power-Up can only be used onece per game")
            }   else    {
                powerUp.usePowerUp()
                self.collectionView.reloadData()
                self.dismiss(animated: true, completion: {
                    finish in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
                })
            }
        }
    }
    
    
    func showStore(storeType: StoreItemType){
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "store") as! StoreMainViewController
//        vc.storeToShow = storeType
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
        self.selectedStoreType = storeType
        self.performSegue(withIdentifier: "powerUpShowStoreView", sender: nil)
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "powerUpShowStoreView"){
            let vc = segue.destination as! StoreMainViewController
            vc.storeToShow = self.selectedStoreType
            //let nav = barViewControllers.viewControllers![3] as! UINavigationController
            //let destinationViewController = nav.viewControllers[0] as! SettingsViewController
        }
    }
   

}
