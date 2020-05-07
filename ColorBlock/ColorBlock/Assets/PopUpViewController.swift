//
//  PopUpViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var LastLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        let LastScore = defaults.string(forKey: "Last_Score")
        // Do any additional setup after loading the view.
        
        if (LastScore == nil){
            LastLabel.text = "You Scored: 0"
        } else {
            LastLabel.text = "You Scored: \(LastScore.unsafelyUnwrapped)"
        }
    }
    

}
