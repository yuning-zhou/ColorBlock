//
//  SoundViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/6/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit

class SoundViewController: UIViewController {

    var initialValue: Int!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var bubbleButton: UIButton!
    @IBOutlet weak var alienButton: UIButton!
    var selected: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var sound = 0
        let defaults = UserDefaults.standard
             
            
        if (defaults.string(forKey: "sound") != nil){
                sound = Int(defaults.string(forKey: "sound")!)!
            }
            
        switch sound
        {
            case 0:
                selected = defaultButton
            case 1:
                selected = bubbleButton
            case 2:
                selected = alienButton
            default:
                break
        }
            
        selected.backgroundColor = .red
        
        
        initialValue = sound
    }
    
    @IBAction func colorChanged(sender: UIButton) {
        let defaults = UserDefaults.standard
        
        switch sender.titleLabel?.text
        {
        case "Default":
            defaults.set(String(0), forKey : "sound")
            sender.backgroundColor = .red
        case "Bubble":
            defaults.set(String(1), forKey : "sound")
            sender.backgroundColor = .red
        case "Alien":
            defaults.set(String(2), forKey : "sound")
            sender.backgroundColor = .red
        default:
            break
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(initialValue), forKey : "color")
        
    }


}
