//
//  ColorViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    var initialValue: Int!
    
    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var colorSwitch: UISegmentedControl!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bezierPath1 = UIBezierPath(roundedRect: selectorLabel.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 30, height: 30))
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

        var color = 0
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "theme") != nil){
            color = Int(defaults.string(forKey: "theme")!)!
        }
        initialValue = color
        colorSwitch.selectedSegmentIndex = color
        switch colorSwitch.selectedSegmentIndex {
        case 0:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme1")!)
        case 1:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme2")!)
        case 2:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme3")!)
        default:
            break
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch colorSwitch.selectedSegmentIndex
        {
        case 0:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme1")!)
            initialValue = 0
        case 1:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme2")!)
            initialValue = 1
        case 2:
            colorView.backgroundColor = UIColor(patternImage: UIImage(named: "theme3")!)
            initialValue = 2
        default:
            break
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(initialValue), forKey: "theme")
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
    }
    
}
