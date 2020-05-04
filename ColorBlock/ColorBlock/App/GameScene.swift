//
//  GameScene.swift
//  ColorBlock
//
//  Created by Zhou Yuning on 5/3/20.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    var block: SKSpriteNode!
    
    enum colorSchemes{
        static let colors = [
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        ]
    }
    
    override func didMove(to view: SKView) {
        setPhysics()
        layoutScene()
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        block.position.x -= block.size.width
    }
    
    @objc
    func swipeRight(sender: UISwipeGestureRecognizer) {
        block.position.x += block.size.width
    }
    
    func setPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
    }
   
    func layoutScene(){
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 189/255, alpha: 1.0)
        spawnBlocks()
    }
    
    func spawnBlocks(){
        let blockColor = Int.random(in: 0 ..< 3)
        
        
        block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/7, height: self.frame.size.width/7))
        block.colorBlendFactor = 1.0
        //block.name = "block"
        
        //block.color = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1.0)
        
        //block.size = CGSize(width: frame.size.width/7, height: frame.size.width/7)
        
        // randomize x-position of spawn
        let index = Int.random(in: 0 ..< 7)
        let top = frame.maxY - block.size.width*2
        let xValue = frame.minX + CGFloat(Double(index) + 0.5) * block.size.width
        
        block.position = CGPoint(x: xValue, y: top)
        block.physicsBody = SKPhysicsBody(circleOfRadius: block.size.width/2)
        
     
        block.physicsBody?.friction = 0.0
        block.physicsBody?.restitution = 0.0
        //block.physicsBody?.velocity = CGVector(dx: 0, dy: -3)
        
        
        let edgeFrame = CGRect(origin: CGPoint(x: frame.minX ,y: frame.minY), size: CGSize(width: frame.width, height: frame.height))
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
        self.physicsBody?.restitution = 0.0
        
        
        
        let blockCategory:UInt32 = 0x1
        let frameCategory:UInt32 = 0x1 << 1
        self.physicsBody?.categoryBitMask = frameCategory
    
        block.physicsBody?.categoryBitMask = blockCategory
        block.physicsBody?.contactTestBitMask = blockCategory | frameCategory
        block.physicsBody?.collisionBitMask = blockCategory | frameCategory
    
        let xRange = SKRange(lowerLimit:0,upperLimit:size.width)
        let yRange = SKRange(lowerLimit:-20,upperLimit:size.height)
        block.constraints = [SKConstraint.positionX(xRange,y:yRange)]
        
        addChild(block)
    }
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (block.position.y - frame.minY <= block.size.height){
            print("iowuwe")
            self.spawnBlocks()
        } else {
            
        }
        
        
        
        //self.spawnBlocks()
    }
}
