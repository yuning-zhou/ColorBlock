//
//  PauseViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 67/255, green: 60/255, blue: 53/255, alpha: 0.4)
        
        let bezierPath = UIBezierPath(roundedRect: resumeButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        resumeButton.layer.mask = maskLayer;
        resumeButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        let bezierPath2 = UIBezierPath(roundedRect: quitButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer2 = CAShapeLayer()
        maskLayer2.path = bezierPath2.cgPath
        quitButton.layer.mask = maskLayer2;
        quitButton.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
    }
}
