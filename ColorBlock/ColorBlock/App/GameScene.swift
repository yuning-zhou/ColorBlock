//
//  GameScene.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/3/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
   
    func layoutScene(){
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 189/255, alpha: 1.0)
        spawnBlocks()
    }
    
    func spawnBlocks(){
        let block = SKSpriteNode(imageNamed: "block")
        
        block.color = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1.0)
        
        block.size = CGSize(width: frame.size.width/7, height: frame.size.width/7)
        
        block.position = CGPoint(x: frame.midX, y: frame.maxY - block.size.width)
        addChild(block)
    }
}
