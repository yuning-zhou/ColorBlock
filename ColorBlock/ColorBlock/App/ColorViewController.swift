//
//  ColorViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/6/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    var initialValue: Int!
    @IBOutlet weak var colorSwitch: UISegmentedControl!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var color = 0
        let defaults = UserDefaults.standard
         
        
        if (defaults.string(forKey: "color") != nil){
            color = Int(defaults.string(forKey: "color")!)!
        }
        
        colorSwitch.selectedSegmentIndex = color
        
        switch colorSwitch.selectedSegmentIndex
        {
        case 0:
            colorView.backgroundColor = .yellow
        case 1:
            colorView.backgroundColor = .green
        case 2:
            colorView.backgroundColor = .blue
        default:
            break
        }
    
        initialValue = color
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        switch colorSwitch.selectedSegmentIndex
        {
        case 0:
            defaults.set(String(0), forKey : "color")
            colorView.backgroundColor = .yellow
        case 1:
            defaults.set(String(1), forKey : "color")
            colorView.backgroundColor = .green
        case 2:
            defaults.set(String(2), forKey : "color")
            colorView.backgroundColor = .blue
        default:
            break
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(initialValue), forKey : "color")
    }
    
}
