//
//  SoundViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    var initialValue: Int!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var bubbleButton: UIButton!
    @IBOutlet weak var alienButton: UIButton!
    var selected: UIButton!
    var player: AVAudioPlayer?
    var url: URL!
    
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
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        let defaults = UserDefaults.standard
        selected.backgroundColor = .green
        
        switch sender.titleLabel?.text
        {
        case "Default":
            url = Bundle.main.url(forResource: "hit", withExtension: "wav")
            defaults.set(String(0), forKey : "sound")
            sender.backgroundColor = .red
        case "Bubble":
            url = Bundle.main.url(forResource: "bubble", withExtension: "wav")
            defaults.set(String(1), forKey : "sound")
            sender.backgroundColor = .red
        case "Alien":
            url = Bundle.main.url(forResource: "alien", withExtension: "wav")
            defaults.set(String(2), forKey : "sound")
            sender.backgroundColor = .red
        default:
            break
        }
        player = try! AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        player?.play()
        selected = sender
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(String(initialValue), forKey : "sound")
        
    }


}
