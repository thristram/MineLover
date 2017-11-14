//
//  LevelSelectViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MIBlurPopupDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var newGameButtomBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    let reuseIdentifier = "LevelSelectCell"
    var selectedLevel: Int = 2
    var startNewGame: Bool = false
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LevelBackToMenu"), object: nil, userInfo: [:])
    }
    @IBAction func newGamePressed(_ sender: Any) {
        if self.startNewGame{
            MinesLover.isLevelChanged = true
            MinesLover.currentLevel = selectedLevel
            MinesLover.startNewGame()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
            self.dismiss(animated: true, completion: {
                finish in
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissMenu"), object: nil, userInfo: [:])
            })
        }   else    {
            self.dismiss(animated: true, completion: {
                finish in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissMenu"), object: nil, userInfo: [:])

            })
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView!.register(UINib(nibName: "LevelSelectCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.newGameButton.layer.borderColor = UIColor(hex: 0xFFFFFF).cgColor
        self.selectedLevel = MinesLover.currentLevel
        self.newGameButtomBottomHeight.constant = CGFloat(MinesLover.UIElements["menuBottomHeight"]!) + 25
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        self.updateNewGameButton()
        // Do any additional setup after loading the view.
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch MinesLover.screenSize(){
    
        default:
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 68)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MinesLover.levels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LevelSelectCollectionViewCell
        let index = indexPath.item
        
        cell.cellView.clipsToBounds = true
        cell.cellView.layer.cornerRadius = 8
        cell.cellView.backgroundColor = UIColor(hex: 0x1B1B1B)
        cell.cellTitle.text = MinesLover.getLevelTitle(level: index + 1)
        
        if self.selectedLevel == (index + 1){
            cell.cellView.layer.borderColor = UIColor.seraphDarkPurple.cgColor
        }   else    {
            cell.cellView.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.selectedLevel = index + 1
        self.collectionView.reloadData()
        self.updateNewGameButton()
        
    }
    func updateNewGameButton(){
        if self.selectedLevel != MinesLover.currentLevel{
            self.newGameButton.setTitle("NEW GAME", for: .normal)
            self.startNewGame = true
        }   else    {
            self.newGameButton.setTitle("RESUME", for: .normal)
            self.startNewGame = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
