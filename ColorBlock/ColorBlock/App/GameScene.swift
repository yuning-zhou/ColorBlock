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
    var matrix = [[SKSpriteNode?]](repeating: [SKSpriteNode?](repeating: nil, count: 0), count: 6)
    var column: Int!
    var shifted: Bool!
    
    enum colorSchemes{
        static let colors = [
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
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
            column -= 1
        }
    }
    
    @objc
    func swipeRight(sender: UISwipeGestureRecognizer) {
        if (block.position.x + block.size.width*1.5 <= frame.maxX){
            block.position.x += block.size.width
            column += 1
        }
    }
    
    func setPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
    }
   
    func layoutScene(){
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 189/255, alpha: 1.0)
        shifted = false
        spawnBlocks()
    }
    
    func spawnBlocks(){
        let blockColor = Int.random(in: 0 ..< 5)
        let factor = CGFloat(7)
        if blockColor == 3 {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "vRainbow"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "verticalRainbow"
        } else if blockColor == 4 {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "hRainbow"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "horizontalRainbow"
        } else {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "block"
            
        }
        block.colorBlendFactor = 1.0
        let storeInfo = NSMutableDictionary()
        storeInfo["color"] = blockColor
        block.userData = storeInfo
        
        
        
        // randomize x-position of spawn
        let index = Int.random(in: 0 ..< 6)
        column = index + 1
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
        
        if (test < block.size.width/3){
            block.physicsBody?.pinned = true
            matrix[column - 1].append(block)
            
            //implement merging logic
            // check vertically
            let v = checkVertical()
            
            // check horizontally
            if (!v){
                checkHorizontal()
            }
            
            if (shifted){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // pin all blocks
                    for x in (0..<6){
                        for y in self.matrix[x]{
                            y?.physicsBody?.pinned = true
                        }
                    }
                }
                shifted = false
            }
            
            // call the next block
            self.spawnBlocks()
        }
        
    }
    func checkVertical() -> Bool{
        let current = matrix[column - 1]
        
        if (block.name == "verticalRainbow"){
            // remove entire column
            for x in matrix[column - 1]{
                x?.removeFromParent()
                matrix[column - 1].removeAll()
            }
            return true
        } else {
            if (current.count >= 3){
                // valid for a check
                let color1 = current[current.count - 1]?.userData?.value(forKey: "color")
                let color2 = current[current.count - 2]?.userData?.value(forKey: "color")
                let color3 = current[current.count - 3]?.userData?.value(forKey: "color")
                
                
                if (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3)){
                    // remove blocks
                    current[current.count - 3]?.removeFromParent()
                    matrix[column - 1].remove(at: matrix[column - 1].count - 3)
                    
                    current[current.count - 2]?.removeFromParent()
                    matrix[column - 1].remove(at: matrix[column - 1].count - 2)
                    
                    current[current.count - 1]?.removeFromParent()
                    matrix[column - 1].remove(at: matrix[column - 1].count - 1)
                    return true
                } else {
                    return false
                }
                
            } else {
                return false
            }
        }
    }
    
    func checkHorizontal(){
        // check if 'tetris' condition is fulfilled
        let current = matrix[column - 1]
        let tempCount = matrix[column - 1].count
        if (block.name == "horizontalRainbow") {
            current[current.count - 1]?.removeFromParent()
            matrix[column - 1].remove(at: tempCount - 1)
            
            for x in (0..<6){
                // remove all blocks in the same line if not nil
                
                if (matrix[x].count >= tempCount){
                    matrix[x][tempCount - 1]?.removeFromParent()
                    matrix[x].remove(at: tempCount - 1)
                    if (matrix[x].count > 0){
                        for y in matrix[x]{
                            y?.physicsBody?.pinned = false
                        }
                    }
                }
            }
            shifted = true
        } else {
            // check if all columns are filled
                   var fullLine = true
                   
                   for x in (0..<6) {
                       if (matrix[x].count < matrix[column - 1].count){
                           fullLine = false
                           break
                       }
                   }
                   
                   // check if same color
                   if (fullLine){
                       // valid for a check
                       let color1 = matrix[0][current.count - 1]?.userData?.value(forKey: "color")
                       let color2 = matrix[1][current.count - 1]?.userData?.value(forKey: "color")
                       let color3 = matrix[2][current.count - 1]?.userData?.value(forKey: "color")
                       let color4 = matrix[3][current.count - 1]?.userData?.value(forKey: "color")
                       let color5 = matrix[4][current.count - 1]?.userData?.value(forKey: "color")
                       let color6 = matrix[5][current.count - 1]?.userData?.value(forKey: "color")
                       
                       let condition = (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3) && isEqual(type: Int.self, a: color3, b: color4) && isEqual(type: Int.self, a: color4, b: color5) && isEqual(type: Int.self, a: color5, b: color6))
                       
                       
                       if (condition){
                           // remove blocks
                           matrix[0][tempCount - 1]?.removeFromParent()
                           matrix[0].remove(at: tempCount - 1)
                           if (matrix[0].count > 0){
                               for x in matrix[0]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           
                           
                           matrix[1][tempCount - 1]?.removeFromParent()
                           matrix[1].remove(at: tempCount - 1)
                           if (matrix[1].count > 0){
                               for x in matrix[1]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           
                           matrix[2][tempCount - 1]?.removeFromParent()
                           matrix[2].remove(at: tempCount - 1)
                           if (matrix[2].count > 0){
                               for x in matrix[2]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           
                           matrix[3][tempCount - 1]?.removeFromParent()
                           matrix[3].remove(at: tempCount - 1)
                           if (matrix[3].count > 0){
                               for x in matrix[3]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           
                           matrix[4][tempCount - 1]?.removeFromParent()
                           matrix[4].remove(at: tempCount - 1)
                           if (matrix[4].count > 0){
                               for x in matrix[4]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           
                           matrix[5][tempCount - 1]?.removeFromParent()
                           matrix[5].remove(at: tempCount - 1)
                           if (matrix[5].count > 0){
                               for x in matrix[5]{
                                   x?.physicsBody?.pinned = false
                               }
                           }
                           shifted = true
                           
                       }
                   }
        }
        
       
    }
    
 
 
    // compare Any type, code snipet from https://stackoverflow.com/questions/34778950/how-to-compare-any-value-types
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
        guard let a = a as? T, let b = b as? T else { return false }

        return a == b
    }
    
    // check for nil object, code snipet from https://stackoverflow.com/questions/26686948/how-to-check-object-is-nil-or-not-in-swift
    func isObjectNotNil(object:AnyObject!) -> Bool
    {
        if let _:AnyObject = object
        {
            return true
        }
        return false
    }
    
}


