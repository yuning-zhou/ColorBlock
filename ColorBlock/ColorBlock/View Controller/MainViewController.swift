//
//  MainViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var archButton: UIButton!
    
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let bezierPath1 = UIBezierPath(roundedRect: scoreButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = bezierPath1.cgPath
        scoreButton.layer.mask = maskLayer1;
        
        let bezierPath2 = UIBezierPath(roundedRect: playButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = bezierPath2.cgPath
        playButton.layer.mask = maskLayer2;

        let bezierPath3 = UIBezierPath(roundedRect: settingButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer3 = CAShapeLayer()
        maskLayer3.path = bezierPath3.cgPath
        settingButton.layer.mask = maskLayer3;

        let bezierPath4 = UIBezierPath(roundedRect: archButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer4 = CAShapeLayer()
        maskLayer4.path = bezierPath4.cgPath
        archButton.layer.mask = maskLayer4;
        
    }
   

}
