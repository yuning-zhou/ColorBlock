//
//  GameViewController.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/3/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, TransitionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.delegate = self as TransitionDelegate
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            
        }
    }
    
    func goToPopUpView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard  let storyboard = appDelegate.window?.rootViewController?.storyboard else { return }
        let vc = storyboard.instantiateViewController(withIdentifier: "popUpView")
        self.present(vc, animated: true, completion: nil)
        
    }


}
