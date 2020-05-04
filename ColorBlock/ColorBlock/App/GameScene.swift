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
    var column: Int!
    
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
        spawnBlocks()
    }
    
    func spawnBlocks(){
        let blockColor = Int.random(in: 0 ..< 3)
        
        let factor = CGFloat(7)
        block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.colors[blockColor], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
        block.colorBlendFactor = 1.0
        block.name = "block"
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
            
            // add to array
            var currentCol = array6
            switch(column){
                case 1:
                    array1.append(block)
                    currentCol = array1
                case 2:
                    array2.append(block)
                    currentCol = array2
                case 3:
                    array3.append(block)
                    currentCol = array3
                case 4:
                    array4.append(block)
                    currentCol = array4
                case 5:
                    array5.append(block)
                    currentCol = array5
                default:
                    array6.append(block)
                    currentCol.append(block)
                    break
            }
            
            //implement merging logic
            // check vertically
            checkVertical(current: &currentCol)
            
            // check horizontally
            //checkHorizontal(current: &currentCol)
            
            
            
            // call the next block
            self.spawnBlocks()
        }
        
    }
    func checkVertical(current: inout [SKSpriteNode]){
        
        if (current.count >= 3){
            // valid for a check
            let color1 = current[current.count - 1].userData?.value(forKey: "color")
            let color2 = current[current.count - 2].userData?.value(forKey: "color")
            let color3 = current[current.count - 3].userData?.value(forKey: "color")
            
            
            if (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3)){
                // cancel blocks
                removeBlock(array: &current, index: current.count - 3);
                removeBlock(array: &current, index: current.count - 2);
                removeBlock(array: &current, index: current.count - 1);
            }
            //print(current)
        }
    }
    
    func checkHorizontal(current: inout [SKSpriteNode]){
        if (column == 1){
            // leftmost column
            
            if (array2.count >= array1.count && array3.count >= array1.count){
                // valid for a check
                let color1 = current[current.count - 1].userData?.value(forKey: "color")
                let color2 = array2[current.count - 1].userData?.value(forKey: "color")
                let color3 = array3[current.count - 1].userData?.value(forKey: "color")
                
                
                if (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3)){
                    // cancel blocks
                    removeBlock(array: &current, index: current.count - 1);
                    removeBlock(array: &array2, index: current.count - 1);
                    removeBlock(array: &array3, index: current.count - 1);
                }
            }
            
            
        } else if (column == 6){
            // rightmost column
            
            if (array5.count >= array6.count && array4.count >= array6.count){
                // valid for a check
                let color1 = current[current.count - 1].userData?.value(forKey: "color")
                let color2 = array4[current.count - 1].userData?.value(forKey: "color")
                let color3 = array5[current.count - 1].userData?.value(forKey: "color")
                
                
                if (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3)){
                    // cancel blocks
                    removeBlock(array: &current, index: current.count - 1);
                    removeBlock(array: &array4, index: current.count - 1);
                    removeBlock(array: &array5, index: current.count - 1);
                }
            }
            
        } else {
            // middle columns
            var leftCol = array1
            var rightCol = array6
            switch(column){
                case 2:
                    rightCol = array3
                case 3:
                    leftCol = array2
                    rightCol = array4
                case 4:
                    leftCol = array3
                    rightCol = array5
                case 5:
                    leftCol = array4
                default:
                    break
            }
            
            if (leftCol.count >= current.count && rightCol.count >= current.count){
                // valid for a check
                print("leftcol: ")
                print(leftCol.count)
                print("rightcol: ")
                print(rightCol.count)
                let color1 = current[current.count - 1].userData?.value(forKey: "color")
                let color2 = leftCol[current.count - 1].userData?.value(forKey: "color")
                let color3 = rightCol[current.count - 1].userData?.value(forKey: "color")
                
                
                if (isEqual(type: Int.self, a: color1, b: color2) && isEqual(type: Int.self, a: color2, b: color3)){
                    // cancel blocks
                    removeBlock(array: &current, index: current.count - 1);
                    removeBlock(array: &leftCol, index: current.count - 1);
                    removeBlock(array: &rightCol, index: current.count - 1);
                }
            }
        }
    }
    
    // compare Any type, code snipet from https://stackoverflow.com/questions/34778950/how-to-compare-any-value-types
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
        guard let a = a as? T, let b = b as? T else { return false }

        return a == b
    }
    
    func removeBlock(array: inout [SKSpriteNode], index: Int){
        print(array.count)
        print(index)
        array[index].removeFromParent()
        array.remove(at: index)
        switch(column){
            case 1:
                array1.remove(at: index)
            case 2:
                array2.remove(at: index)
            case 3:
                array3.remove(at: index)
            case 4:
                array4.remove(at: index)
            case 5:
                array5.remove(at: index)
            default:
                array6.remove(at: index)
                break
        }
        
        print("removed")
    }
}
