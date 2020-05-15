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

    @IBOutlet weak var selectorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var bubbleButton: UIButton!
    @IBOutlet weak var alienButton: UIButton!
    
    var selected: UIButton!
    var player: AVAudioPlayer?
    var url: URL!
    var initialValue: Int!
        
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

        let bezierPath4 = UIBezierPath(roundedRect: defaultButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer4 = CAShapeLayer()
        maskLayer4.path = bezierPath4.cgPath
        defaultButton.layer.mask = maskLayer4;
        defaultButton.backgroundColor = UIColor.init(red: 242/255, green: 250/255, blue: 255/255, alpha: 1)

        let bezierPath5 = UIBezierPath(roundedRect: bubbleButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer5 = CAShapeLayer()
        maskLayer5.path = bezierPath5.cgPath
        bubbleButton.layer.mask = maskLayer5;
        bubbleButton.backgroundColor = UIColor.init(red: 242/255, green: 250/255, blue: 255/255, alpha: 1)

        let bezierPath6 = UIBezierPath(roundedRect: alienButton.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 25, height: 25))
        let maskLayer6 = CAShapeLayer()
        maskLayer6.path = bezierPath6.cgPath
        alienButton.layer.mask = maskLayer6;
        alienButton.backgroundColor = UIColor.init(red: 242/255, green: 250/255, blue: 255/255, alpha: 1)


        var sound = 0
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "sound") != nil) {
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
        
        selected.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        
        initialValue = sound
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        let defaults = UserDefaults.standard
        selected.backgroundColor = UIColor.init(red: 242/255, green: 250/255, blue: 255/255, alpha: 1)
        sender.backgroundColor = UIColor.init(red: 118/255, green: 161/255, blue: 187/255, alpha: 1.0)
        
        switch sender.titleLabel?.text
        {
        case "Default":
            url = Bundle.main.url(forResource: "hit", withExtension: "wav")
            defaults.set(String(0), forKey : "sound")
        case "Bubble":
            url = Bundle.main.url(forResource: "bubble", withExtension: "wav")
            defaults.set(String(1), forKey : "sound")
        case "Alien":
            url = Bundle.main.url(forResource: "alien", withExtension: "wav")
            defaults.set(String(2), forKey : "sound")
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
