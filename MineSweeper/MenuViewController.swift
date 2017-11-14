//
//  MenuViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    ////////////////////////////////
    //////////MENU ELEMENTS/////////
    ////////////////////////////////
    
    var gameState: GameState = .pendingStart
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var menuBottomHeight: NSLayoutConstraint!
    
    //MENU BUTTONS
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //OTHERS
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var levelSegmentControl: UISegmentedControl!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuText1: UILabel!
    @IBOutlet weak var menuText2: UILabel!
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBAction func levelSelected(_ sender: UISegmentedControl) {
        let selectedLevel = sender.selectedSegmentIndex + 1
        if MinesLover.currentLevel != selectedLevel{
            MinesLover.isLevelChanged = true
            MinesLover.currentLevel = selectedLevel
        }
    }
    @IBAction func newGameButtonPressed(_ sender: Any) {
        
        MinesLover.startNewGame()
        self.dismiss(animated: false, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
        
    }
    
    @IBAction func selectLevel(_ sender: Any) {

        let selectedLevel = (sender as AnyObject).selectedSegmentIndex + 1
        MinesLover.setCurrentLevel(newLevel: selectedLevel)
    }
    
    @IBAction func switchToLeaderboard(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderboard") as! LeaderboardViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
        
        performSegue(withIdentifier: "menuShowLeaderboard", sender: nil)
    }

    
    @IBAction func switchToStore(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "store") as! StoreMainViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
        
        performSegue(withIdentifier: "menuShowStoreView", sender: nil)
    }
    
    @IBAction func switchToLevelSelect(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "levelSelect") as! LevelSelectViewController
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0
        })
        performSegue(withIdentifier: "showLevelSelect", sender: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tryAgainButton.layer.borderColor = UIColor.white.cgColor
        self.resumeButton.layer.borderColor = UIColor.white.cgColor
        self.levelSegmentControl.selectedSegmentIndex = MinesLover.currentLevel - 1
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        self.menuBottomHeight.constant = CGFloat(MinesLover.UIElements["menuBottomHeight"]!)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.versionLabel.text = "MineLover v\(version) Build \(build)"
            }
        }
        self.iconView.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldDismissMenu(_:)), name: NSNotification.Name(rawValue: "dismissMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willBackToMenu(_:)), name: NSNotification.Name(rawValue: "LevelBackToMenu"), object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timerLabel.text = MinesLover.publicMethods.formatMineDisplay(mineInput: MinesLover.getCurrentLevel().mines)
        
        let timeCounter = MinesLover.timerCounter
        
        let min = (timeCounter / 100) / 60;
        let sec = (timeCounter / 100) % 60;
        if(sec < 10){
            self.timerLabel.text = "\(min):0\(sec)"
        }   else{
            self.timerLabel.text = "\(min):\(sec)"
        }
        
        switch MinesLover.gameState{

        case .win:
            self.menuText1.text = "You got everything"
            self.menuText2.text = "I Love You"
            self.menuIcon.image = UIImage(named: "smile");
            self.resumeButton.setTitle("BACK TO MAP", for: .normal)
            self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
            break;
            
        case .lose:
            
            self.menuText1.text = "You found \(MinesLover.sweepCorrected) out"
            self.menuText2.text = "of \(MinesLover.getCurrentLevelMines()) mines"
            
            self.menuIcon.image = UIImage(named: "cry");
            self.resumeButton.setTitle("BACK TO MAP", for: .normal)
            self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
            break;
            
        default:
            self.menuText1.text = "Paused";
            self.menuText2.text = "Click resume to play";
            self.menuIcon.image = UIImage(named: "pause");
            self.resumeButton.setTitle("RESUME", for: .normal)
            self.tryAgainButton.setTitle("NEW GAME", for: .normal)
            break;

        }
    }

    func shouldDismissMenu(_ notification: NSNotification){
        self.dismiss(animated: false, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
    }
    func willBackToMenu(_ notification: NSNotification){
        self.view.alpha = 1
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
