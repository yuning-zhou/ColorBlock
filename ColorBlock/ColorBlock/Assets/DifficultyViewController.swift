//
//  DifficultyViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var difficultySwitch: UISegmentedControl!
    
    var initialValue: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bezierPath1 = UIBezierPath(roundedRect: selectorLabel.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = bezierPath1.cgPath
        selectorLabel.layer.mask = maskLayer1;
        selectorLabel.textColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)

        let bezierPath2 = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = bezierPath2.cgPath
        saveButton.layer.mask = maskLayer2;
        saveButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)

        let bezierPath3 = UIBezierPath(roundedRect: cancelButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = bezierPath3.cgPath
        cancelButton.layer.mask = maskLayer3;
        cancelButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)


        var difficulty = 0
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "difficulty") != nil) {
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
