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

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back.png")!)
        
        ScoreLabel.textColor = .white
        LastLabel.textColor = .white
        
        let defaults = UserDefaults.standard

        let HighScore = defaults.string(forKey: "High_Score")
        // Do any additional setup after loading the view.
        
        if (HighScore == nil){
            ScoreLabel.text = "High Score: 0"
        } else {
            ScoreLabel.text = "High Score: \(HighScore.unsafelyUnwrapped)"
        }
        
        let LastScore = defaults.string(forKey: "Last_Score")
        
        if (LastScore == nil){
            LastLabel.text = "Last Score: 0"
        } else {
            LastLabel.text = "Last Score: \(LastScore.unsafelyUnwrapped)"
        }
        
    }

}
