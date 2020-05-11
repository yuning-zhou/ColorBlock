//
//  AchievementsViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    @IBOutlet weak var ach1: UIButton!
    @IBOutlet weak var ach2: UIButton!
    @IBOutlet weak var ach3: UIButton!
    @IBOutlet weak var ach4: UIButton!
    @IBOutlet weak var ach5: UIButton!
    @IBOutlet weak var ach6: UIButton!
    @IBOutlet weak var ach7: UIButton!
    @IBOutlet weak var achiButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bezierPath1 = UIBezierPath(roundedRect: achiButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = bezierPath1.cgPath
        achiButton.layer.mask = maskLayer1;


        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "ach1") != nil){
            ach1.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach2") != nil){
            ach2.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach3") != nil){
            ach3.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach4") != nil){
            ach4.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach5") != nil){
            ach5.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach6") != nil){
            ach6.backgroundColor = .green
        }
        
        if (defaults.string(forKey: "ach7") != nil){
            ach7.backgroundColor = .green
        }
        
    }
    

}
