//
//  ScoreViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var LastLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ScoreLabel.textColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        LastLabel.textColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        let defaults = UserDefaults.standard

        let HighScore = defaults.string(forKey: "High_Score")
        // Do any additional setup after loading the view.
        
        if (HighScore == nil){
            ScoreLabel.text = "High Score: 0"
        } else {
            ScoreLabel.text = "High Score: \(HighScore.unsafelyUnwrapped)"
        }
        
        let LastScore = defaults.string(forKey: "Last_Score")
        // Do any additional setup after loading the view.
        
        if (LastScore == nil){
            LastLabel.text = "Last Score: 0"
        } else {
            LastLabel.text = "Last Score: \(LastScore.unsafelyUnwrapped)"
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
