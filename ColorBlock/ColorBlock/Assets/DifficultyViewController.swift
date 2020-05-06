//
//  DifficultyViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/6/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet weak var difficultySwitch: UISegmentedControl!
    
    var initialValue: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var difficulty = 0
        let defaults = UserDefaults.standard
         
        
        if (defaults.string(forKey: "difficulty") != nil){
            difficulty = Int(defaults.string(forKey: "difficulty")!)!
        }
        
        difficultySwitch.selectedSegmentIndex =  difficulty
        initialValue = difficulty
       
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        switch difficultySwitch.selectedSegmentIndex
        {
        case 0:
            defaults.set(String(0), forKey : "difficulty")
        case 1:
            defaults.set(String(1), forKey : "difficulty")
        default:
            break
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(initialValue), forKey : "difficulty")
    }

}
