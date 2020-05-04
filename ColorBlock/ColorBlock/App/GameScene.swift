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
    var array1 = [SKSpriteNode]()
    var array2 = [SKSpriteNode]()
    var array3 = [SKSpriteNode]()
    var array4 = [SKSpriteNode]()
    var array5 = [SKSpriteNode]()
    var array6 = [SKSpriteNode]()
    
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
        if (block.position.x - block.size.width*1.5 >= frame.minX){
            block.position.x -= block.size.width
        }
    }
    
    @objc
    func swipeRight(sender: UISwipeGestureRecognizer) {
        if (block.position.x + block.size.width*1.5 <= frame.maxX){
            block.position.x += block.size.width
        }
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
        
        let factor = CGFloat(7)
        block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
        block.colorBlendFactor = 1.0
        block.name = "block"
        
        
        // randomize x-position of spawn
        let index = Int.random(in: 0 ..< 6)
        let top = frame.maxY - block.size.width*2
        let xValue = frame.minX + CGFloat(Double(index) + 0.8) * block.size.width
        
        
        block.position = CGPoint(x: xValue, y: top)
        block.physicsBody = SKPhysicsBody(circleOfRadius: block.size.width/2)
        
     
        block.physicsBody?.friction = 0.0
        block.physicsBody?.restitution = 0.0
        //block.physicsBody?.usesPreciseCollisionDetection = true
        
        //block.physicsBody?.velocity = CGVector(dx: 0, dy: -3)
        
        
        let edgeFrame = CGRect(origin: CGPoint(x: frame.minX, y: frame.minY), size: CGSize(width: (self.view?.frame.width)!, height: (self.view?.frame.height)!))
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
        // bottom || on top of other blocks
        
    
        let blockBottom = CGPoint(x: block.frame.origin.x + block.frame.width/2, y: block.frame.origin.y)
        
        let xDist = (contact.contactPoint.x - blockBottom.x)
        let yDist = (contact.contactPoint.y - blockBottom.y)
        let test = CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
        print(test)
        print(block.size.width/3)
        if (test < block.size.width/3){
            block.physicsBody?.pinned = true
            
            // implement merging logic
            
            
            
            
            
            
            
            // call the next block
            self.spawnBlocks()
        }
        
    }
}
