//
//  SettingsViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var difficultyButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    
    @IBAction func unwindToSettingsViewController(segue: UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        
        let bezierPath1 = UIBezierPath(roundedRect: difficultyButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = bezierPath1.cgPath
        difficultyButton.layer.mask = maskLayer1;
        difficultyButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        let bezierPath2 = UIBezierPath(roundedRect: soundButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = bezierPath2.cgPath
        soundButton.layer.mask = maskLayer2;
        soundButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        let bezierPath3 = UIBezierPath(roundedRect: colorButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 30, height: 30))
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = bezierPath3.cgPath
        colorButton.layer.mask = maskLayer3;
        colorButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
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
