//
//  LeaderboardViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import GameKit


class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    ////////////////////////////////
    //////LEADERBOARD ELEMENTS//////
    ////////////////////////////////
    
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backToMenu(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row){
        case 0:
            return 60.0;
        case 6:
            return 180.0;
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row){
            case 0:
            let identfier = "lbTitleCell"
            let cell:LeaderboardTitleTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! LeaderboardTitleTableViewCell
            cell.titleGameCenterButton.tag = indexPath.section
            cell.titleGameCenterButton.addTarget(self, action: #selector(self.GCButtonClickedFromLeaderboardTableView(sender:)), for: UIControlEvents.touchUpInside)
            
            cell.selectionStyle = .none
            
            switch (indexPath.section){
            case 0:
                cell.titleLabel.text = "Easy Mode"
                break;
            case 1:
                cell.titleLabel.text = "Medium Mode"
                break;
            case 2:
                cell.titleLabel.text = "Expert Mode"
                break;
            case 3:
                cell.titleLabel.text = "Crazy Mode"
                break;
            default:
                break;
            }
            return cell
            case 6:
            let identfier = "lbContentCell"
            let cell:LeaderboardContentTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! LeaderboardContentTableViewCell
            cell.selectionStyle = .none
            
            let currentStatistics = getCurrentStatistics(level: (indexPath.section + 1))
            
            print("\n\n//////////////////////////")
            print("        STATISTICS \(indexPath.section + 1)      ")
            print("//////////////////////////\n")
            print("1st Record: \(currentStatistics["1_Date"]!) - \(currentStatistics["1_Record"]!)s")
            print("2nd Record: \(currentStatistics["2_Date"]!) - \(currentStatistics["2_Record"]!)s")
            print("3rd Record: \(currentStatistics["3_Date"]!) - \(currentStatistics["3_Record"]!)s")
            print("4th Record: \(currentStatistics["4_Date"]!) - \(currentStatistics["4_Record"]!)s")
            print("5th Record: \(currentStatistics["5_Date"]!) - \(currentStatistics["5_Record"]!)s")
            
            print("Average Time: \(currentStatistics["averageTime"]!)")
            print("Average Win Time: \(currentStatistics["averageTimeWin"]!)")
            print("Average Lose Time: \(currentStatistics["averageTimeLose"]!)")
            print("Average Exploration Percentage: \(currentStatistics["explorationPercentage"]!)")
            print("Total Wins: \(currentStatistics["totalWin"]!)")
            print("Total Loses: \(currentStatistics["totalLose"]!)")
            print("Total Games: \(currentStatistics["totalGame"]!)")
            print("Longest Game: \(currentStatistics["longestGame"]!)s")
            print("Longest Win Game: \(currentStatistics["longestWin"]!)s")
            print("Longest Lose Game: \(currentStatistics["longestLose"]!)s")
            print("Shortest Lose Game: \(currentStatistics["shortestLose"]!)s")
            print("Total Checked Block: \(currentStatistics["totalChecked"]!)")
            print("Total Mine Sweeped: \(currentStatistics["totalMineSweeped"]!)")
            print("Total Mine Sweeped Wrong: \(currentStatistics["totalMineSweepedWrong"]!)")
            
            cell.lbContent.text = "Average Time:\nExploration Percentage:\nTotal Wins:\nTotal Loses:\nTotal Games:\nTotal Mine Sweeped:";
            cell.lbContentValue.text = "\(MinesLover.publicMethods.sec2Min(time: currentStatistics["averageTimeWin"]!))\n\(currentStatistics["explorationPercentage"]!)%\n\(currentStatistics["totalWin"]!)\n\(currentStatistics["totalLose"]!)\n\(currentStatistics["totalGame"]!)\n\(currentStatistics["totalMineSweeped"]!)"
 
            return cell
            
            default:
            let identfier = "cell"
            let cell:LeaderboardTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! LeaderboardTableViewCell
            
            switch (indexPath.row){
            case 0:
                
                cell.cellBG.backgroundColor = UIColor.clear
                break;
            case 1:
                //let themeColor = UIColor(red: 227/255, green: 110/255, blue: 91/255, alpha: 1.0)
                let themeColor = UIColor(red: 180/255, green: 56/255, blue: 59/255, alpha: 1.0)
                cell.cellBG.backgroundColor = themeColor
                cell.numberLabel.textColor = themeColor
                break;
            case 2:
                //let themeColor = UIColor(red: 197/255, green: 91/255, blue: 81/255, alpha: 1.0)
                let themeColor = UIColor(red: 149/255, green: 52/255, blue: 65/255, alpha: 1.0)
                cell.cellBG.backgroundColor = themeColor
                cell.numberLabel.textColor = themeColor
                break;
            case 3:
                //let themeColor = UIColor(red: 190/255, green: 85/255, blue: 78/255, alpha: 1.0)
                let themeColor = UIColor(red: 149/255, green: 58/255, blue: 86/255, alpha: 1.0)
                cell.cellBG.backgroundColor = themeColor
                cell.numberLabel.textColor = themeColor
                break;
            case 4:
                //let themeColor = UIColor(red: 186/255, green: 82/255, blue: 78/255, alpha: 1.0)
                let themeColor = UIColor(red: 133/255, green: 58/255, blue: 99/255, alpha: 1.0)
                cell.cellBG.backgroundColor = themeColor
                cell.numberLabel.textColor = themeColor
                break;
            case 5:
                //let themeColor = UIColor(red: 155/255, green: 66/255, blue: 66/255, alpha: 1.0)
                let themeColor = UIColor(red: 123/255, green: 62/255, blue: 116/255, alpha: 1.0)
                cell.cellBG.backgroundColor = themeColor
                cell.numberLabel.textColor = themeColor
                break;
            case 6:
                cell.cellBG.backgroundColor = UIColor.clear
                break;
            default:
                cell.cellBG.backgroundColor = UIColor.clear
                break;
            }
            cell.selectionStyle = .none
            cell.numberLabel.text = "\(indexPath.row)"
            
            let currentStatistics = getCurrentStatistics(level: (indexPath.section + 1))
            
            if let currentRecordDate = currentStatistics["\(indexPath.row)_Date"] {
                print("Loading \(indexPath.section + 1)-\(indexPath.row)")
                if(currentRecordDate != "0"){
                    cell.dateLabel.text = self.timestamp2Date(timestamp: currentRecordDate)
                    cell.recordLabel.text = "\(String(describing: sec2Min(time: currentStatistics["\(indexPath.row)_Record"]!)))"
                }   else{
                    cell.dateLabel.text = "N/A"
                    cell.recordLabel.text = "N/A"
                }
            }
            
            
            
            return cell
        }
    }
    
    func GCButtonClickedFromLeaderboardTableView(sender:UIButton){
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        var levelIdentifier = "";
        var HDIdentifier = "";
        if(MinesLover.isiPad){
            HDIdentifier = "HD"
        }
        switch (buttonRow){
        case 0:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.beginner\(HDIdentifier)"
            break;
        case 1:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.medium\(HDIdentifier)"
            break;
        case 2:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.expert\(HDIdentifier)"
            break;
        case 3:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.crazy\(HDIdentifier)"
            break;
        default:
            levelIdentifier = "grp.SeraphTechnology.MineSweeper.lbrd.medium\(HDIdentifier)"
            break;
            
        }
        
        GCHelper.sharedInstance.showGameCenter(self, viewState: .leaderboards, leaderboardID: levelIdentifier)
        
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
