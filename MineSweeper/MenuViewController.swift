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
    
    var menuStatus: MenuState = .pause
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    //COIN & GEMS
    @IBOutlet weak var gemLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    //MENU BUTTONS
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //OTHERS
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var levelSegmentControl: UISegmentedControl!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuText1: UILabel!
    @IBOutlet weak var menuText2: UILabel!
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        
        MinesLover.startNewGame()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func selectLevel(_ sender: Any) {

        let selectedLevel = (sender as AnyObject).selectedSegmentIndex + 1
        MinesLover.setCurrentLevel(newLevel: selectedLevel)
    }
    
    @IBAction func switchToLeaderboard(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "leaderboard") as! LeaderboardViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tryAgainButton.layer.borderColor = UIColor.white.cgColor
        self.resumeButton.layer.borderColor = UIColor.white.cgColor
        self.levelSegmentControl.selectedSegmentIndex = 1;
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.versionLabel.text = "MineLover v\(version) Build \(build)"
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateMenuText()
        switch self.menuStatus{

        case .win:
            self.menuText1.text = "You got everything"
            self.menuText2.text = "I Love You"
            self.menuIcon.image = UIImage(named: "smile");
            self.resumeButton.setTitle("BACK TO MAP", for: .normal)
            self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
            break;
            
        case .gameOver:
            
            self.menuText1.text = "You found \(MinesLover.sweepCorrected) out"
            self.menuText2.text = "of \(MinesLover.getCurrentLevelMines()) mines"
            
            self.menuIcon.image = UIImage(named: "cry");
            self.resumeButton.setTitle("BACK TO MAP", for: .normal)
            self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
            break;
            
        case .pause:
            self.menuText1.text = "Paused";
            self.menuText2.text = "Click resume to play";
            self.menuIcon.image = UIImage(named: "pause");
            self.resumeButton.setTitle("RESUME", for: .normal)
            self.tryAgainButton.setTitle("NEW GAME", for: .normal)
            break;

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMenuText(){
        self.coinLabel.text = "\(MinesLover.Coins)";
        self.gemLabel.text = "\(MinesLover.Gems)";
        
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
