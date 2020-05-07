//
//  GameScene.swift
//  ColorBlock
//
//  Created by Zhou Yuning.
//  Copyright © 2020 Zhou Yuning. All rights reserved.
//

import SpriteKit
protocol TransitionDelegate: SKSceneDelegate {
    func goToPopUpView()
}

class GameScene: SKScene {
    var block: SKSpriteNode!
    var matrix = [[SKSpriteNode?]](repeating: [SKSpriteNode?](repeating: nil, count: 0), count: 6)
    var column: Int!
    var freezeTime: Double!
    var lastScore: SKLabelNode!
    var score = 0
    var highScore: Int!
    var difficulty: Int!
    var difficultyFactor : Double!
    var theme: Int!
    var soundEffect: SKAction! = nil
    var hitSount: Int!
    var bombCount: Int!
    var rainbowCount: Int!
  
    enum colorSchemes{
        static let special = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
        
        static let theme1 = [
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
        
        static let theme2 = [
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
        
        static let theme3 = [
            UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
            UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "difficulty") != nil){
            difficulty = Int(defaults.string(forKey: "difficulty")!)
        } else {
            difficulty = 0
        }
        if (difficulty > 0) {
            // hardcore mode
            difficultyFactor = 0.4
            physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        } else {
            difficultyFactor = 0
            physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        }
        
        physicsWorld.contactDelegate = self
    }
   
    func layoutScene(){
        bombCount = 0
        rainbowCount = 0
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 189/255, alpha: 1.0)
        freezeTime = 0.5
        
        lastScore = SKLabelNode(fontNamed: "Chalkduster")
        lastScore.text = "Score: \(score)"
        lastScore.horizontalAlignmentMode = .right
        lastScore.position = CGPoint(x: frame.width, y: frame.height - 70)
        lastScore.zPosition = 0
        lastScore.fontSize = 40
        lastScore.fontColor = UIColor.black
        addChild(lastScore)
        
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "High_Score") != nil){
            highScore = Int(defaults.string(forKey: "High_Score")!)
        } else {
            highScore = 0
        }
        
        if (defaults.string(forKey: "theme") != nil){
            theme = Int(defaults.string(forKey: "theme")!)
        } else {
            theme = 0
        }
        
        if (defaults.string(forKey: "sound") != nil){
            hitSount = Int(defaults.string(forKey: "sound")!)
        } else {
            hitSount = 0
        }
        
        switch hitSount
        {
            case 0:
                soundEffect = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false)
            case 1:
                print("yes")
                soundEffect = SKAction.playSoundFileNamed("bubble.wav", waitForCompletion: false)
            case 2:
                soundEffect = SKAction.playSoundFileNamed("alien.wav", waitForCompletion: false)
            default:
                break
        }
        
        spawnBlocks()
    }
    
    func spawnBlocks(){
        var blockColor: Int!
        let factor = CGFloat(7)
        lastScore.text = "Score: \(score)"
        
        if (difficulty > 0) {
            // difficult mode
            blockColor = Int.random(in: 0 ..< 20)
        } else {
            blockColor = Int.random(in: 0 ..< 10)
        }
        
        if blockColor == 3 {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "vRainbow"), color: colorSchemes.special[0], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "verticalRainbow"
        } else if blockColor == 4 {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "hRainbow"), color: colorSchemes.special[0], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "horizontalRainbow"
        } else if blockColor == 5 {
            block = SKSpriteNode(texture: SKTexture(imageNamed: "boom"), color: colorSchemes.special[0], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
            block.name = "boom"
        } else {
            switch (theme)
            {
                case 0:
                    block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.theme1[blockColor % 3], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
                    block.name = "block"
                case 1:
                    block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.theme2[blockColor % 3], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
                    block.name = "block"
                case 2:
                    block = SKSpriteNode(texture: SKTexture(imageNamed: "block"), color: colorSchemes.theme3[blockColor % 3], size:CGSize(width: self.frame.size.width/factor, height: self.frame.size.width/factor))
                    block.name = "block"
                default:
                    break
            }
            
            
        }
        
        
        block.colorBlendFactor = 1.0
        let storeInfo = NSMutableDictionary()
        storeInfo["color"] = blockColor % 3
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
            
            // hit bottom
            // process sound
            switch hitSount
            {
                case 0:
                    soundEffect = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false)
                case 1:
                    soundEffect = SKAction.playSoundFileNamed("bubble.wav", waitForCompletion: false)
                case 2:
                    soundEffect = SKAction.playSoundFileNamed("alien.wav", waitForCompletion: false)
                default:
                    break
            }
            block.run(soundEffect)
            
            // process physicsbody
            block.physicsBody?.pinned = true
            block.physicsBody?.allowsRotation = false
            matrix[column - 1].append(block)
            
            //implement merging logic
            // check vertically
            let v = checkVertical()
            
            // check horizontally
            if (!v){
                checkHorizontal()
            }
            
            
            
            if (freezeTime > 0.5){
                DispatchQueue.main.asyncAfter(deadline: .now() + freezeTime) {
                    // pin all blocks
                    for x in (0..<6){
                        for y in self.matrix[x]{
                            y?.physicsBody?.pinned = true
                        }
                    }
                }
                freezeTime = 0.5
            }
            
            // call the next block
            // test if game is over
            if (matrix[column - 1].count >= 5){
                gameOver()
            } else {
                self.spawnBlocks()
            }
           
        }
        
    }
    
    func checkVertical() -> Bool{
        let current = matrix[column - 1]
        
        if (block.name == "boom"){
            bombCount += 1
            boom()
            return true
        }
        
        if (block.name == "verticalRainbow"){
            rainbowCount += 1
            // remove entire column
            for x in matrix[column - 1]{
                x?.removeFromParent()
                matrix[column - 1].removeAll()
                score += 1
                achievement()
            }
            soundEffect = SKAction.playSoundFileNamed("rainbow.flac", waitForCompletion: false)
            self.run(soundEffect)
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
                    
                    score += 3
                    achievement()
                    soundEffect = SKAction.playSoundFileNamed("cancel.flac", waitForCompletion: false)
                    self.run(soundEffect)
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
            rainbowCount += 1
            current[current.count - 1]?.removeFromParent()
            matrix[column - 1].remove(at: tempCount - 1)
            score += 1
            achievement()
            
            for x in (0..<6){
                // remove all blocks in the same line if not nil
                
                if (matrix[x].count >= tempCount){
                    matrix[x][tempCount - 1]?.removeFromParent()
                    matrix[x].remove(at: tempCount - 1)
                    score += 1
                    achievement()
                    if (matrix[x].count > 0){
                        for y in matrix[x]{
                            y?.physicsBody?.pinned = false
                        }
                    }
                }
            }
            soundEffect = SKAction.playSoundFileNamed("rainbow.flac", waitForCompletion: false)
            self.run(soundEffect)
            freezeTime = 1.0 - Double(difficulty) * 0.4
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
                        score += 6
                        achievement()
                        soundEffect = SKAction.playSoundFileNamed("cancel.flac", waitForCompletion: false)
                        self.run(soundEffect)
                        freezeTime = 1.0 - Double(difficulty) * 0.4
                           
                       }
                   }
        }
        
       
    }
 
    func boom(){
        let current = matrix[column - 1]
        let tempCount = matrix[column - 1].count
        // check for left, right, bottom, bottom-left, and bottom-right blocks
        // check for upper-left and upper-right blocks. If they exist, remove them
        
        // remove self
        current[current.count - 1]?.removeFromParent()
        matrix[column - 1].remove(at: tempCount - 1)
        score += 1
        achievement()
        
        // remove bottom
        if (matrix[column - 1].count > 0){
            matrix[column - 1][matrix[column - 1].count - 1]?.removeFromParent()
            matrix[column - 1].remove(at: matrix[column - 1].count - 1)
            score += 1
            achievement()
        }
        
        // remove left 3 blocks
        if (column > 1) {
            let distance = matrix[column - 2].count - tempCount
            if (distance >= -1){
                switch(distance){
                    case -1:
                        // only need to remove bottom-left block
                        if (tempCount > 1){
                            matrix[column - 2][tempCount - 2]?.removeFromParent()
                            matrix[column - 2].remove(at: matrix[column - 2].count - 1)
                            score += 1
                            achievement()
                        }
                    case 0:
                        // need to remove bottom-left and left bocks
                        matrix[column - 2][tempCount - 1]?.removeFromParent()
                        matrix[column - 2].remove(at: matrix[column - 2].count - 1)
                        score += 1
                        achievement()
                        
                        if (tempCount > 1){
                            matrix[column - 2][matrix[column - 2].count - 1]?.removeFromParent()
                            matrix[column - 2].remove(at: matrix[column - 2].count - 1)
                            score += 1
                            achievement()
                        }
                        
                    default:
                        // need to remove bottom-left, left, and upper-left blocks
                        matrix[column - 2][tempCount]?.removeFromParent()
                        matrix[column - 2].remove(at: tempCount)
                    
                        matrix[column - 2][tempCount - 1]?.removeFromParent()
                        matrix[column - 2].remove(at: tempCount - 1)
                        freezeTime = 2.0 - Double(difficulty) * 0.4 / 2
                        
                        score += 2
                        achievement()
                        
                        if (tempCount > 1){
                            matrix[column - 2][tempCount - 2]?.removeFromParent()
                            matrix[column - 2].remove(at: tempCount - 2)
                            freezeTime = 3.0 - Double(difficulty) * 0.4 / 3
                            score += 1
                            achievement()
                        }
                }
                
                if (matrix[column - 2].count > 0){
                    for y in matrix[column - 2]{
                        y?.physicsBody?.pinned = false
                    }
                }
            }
        }
        // remove right 3 blocks
        if (column < 6) {
            let distance = matrix[column].count - tempCount
            if (distance >= -1){
                switch(distance){
                    case -1:
                        // only need to remove bottom-right block
                        if (tempCount > 1){
                            matrix[column][tempCount - 2]?.removeFromParent()
                            matrix[column].remove(at: matrix[column].count - 1)
                            score += 1
                            achievement()
                        }
                    case 0:
                        // need to remove bottom-right and right bocks
                        matrix[column][tempCount - 1]?.removeFromParent()
                        matrix[column].remove(at: matrix[column].count - 1)
                        score += 1
                        achievement()
                       
                        if (tempCount > 1){
                            matrix[column][matrix[column].count - 1]?.removeFromParent()
                            matrix[column].remove(at: matrix[column].count - 1)
                            score += 1
                            achievement()
                        }
                        
                    default:
                        // need to remove bottom-right, right, and upper-right blocks
                        matrix[column][tempCount]?.removeFromParent()
                        matrix[column].remove(at: tempCount)
                    
                        matrix[column][tempCount - 1]?.removeFromParent()
                        matrix[column].remove(at: tempCount - 1)
                        freezeTime = 2.0 - Double(difficulty) * 0.4 / 2
                        score += 2
                        achievement()
                        
                        if (tempCount > 1){
                            matrix[column][tempCount - 2]?.removeFromParent()
                            matrix[column].remove(at: tempCount - 2)
                            freezeTime = 3.0 - Double(difficulty) / 0.4 * 3
                            score += 1
                            achievement()
                        }
                }
                if (matrix[column].count > 0){
                    for y in matrix[column]{
                        y?.physicsBody?.pinned = false
                    }
                }
            }
        
        }
        soundEffect = SKAction.playSoundFileNamed("boom.wav", waitForCompletion: false)
        self.run(soundEffect)
    }
    
    // jump to pop up view controller, code snipet from https://riptutorial.com/sprite-kit/example/29867/multiple-uiviewcontroller-in-a-game--how-to-jump-from-the-scene-to-a-viewcontroller
    func gameOver(){
        let myString = String(score)
        let defaults = UserDefaults.standard
        
        soundEffect = SKAction.playSoundFileNamed("gameover.wav", waitForCompletion: false)
        self.run(soundEffect)
        
        defaults.set(myString, forKey : "Last_Score")
        
        if (score - highScore >= 0){
            defaults.set(myString, forKey : "High_Score")
        }
        
        self.run(SKAction.wait(forDuration: 1),completion:{[unowned self] in
            guard let delegate = self.delegate else { return }
            self.view?.presentScene(nil)
            (delegate as! TransitionDelegate).goToPopUpView()
        })
    }
 
    // compare Any type, code snipet from https://stackoverflow.com/questions/34778950/how-to-compare-any-value-types
    func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
        guard let a = a as? T, let b = b as? T else { return false }

        return a == b
    }
    
    func pauseGame(sender: UIButton) {
        if (sender == GameViewController.instance.pauseButton) {
            scene?.view?.isPaused = true
        }
    }
    
    func resumeGame(){
        scene?.view?.isPaused = false
    }
    
    func achievement(){
        // score-based
        // reach 50 pts
        let defaults = UserDefaults.standard
        var set = false
       
        if (defaults.string(forKey: "ach1") == nil && highScore >= 50 || score >= 50){
            defaults.set("1", forKey : "ach1")
            set = true
        }
        
        // reach 100 pts
        if (defaults.string(forKey: "ach2") == nil && highScore >= 100 || score >= 100){
            defaults.set("1", forKey : "ach2")
            set = true
        }
        
        // reach 200 pts
        if (defaults.string(forKey: "ach3") == nil && highScore >= 200 || score >= 200){
            defaults.set("1", forKey : "ach3")
            set = true
        }
        
        // reach 500 pts
        if (defaults.string(forKey: "ach4") == nil && highScore >= 500 || score >= 500){
            defaults.set("1", forKey : "ach4")
            set = true
        }
        
        // gameplay-based
        // clear the screen
        if (defaults.string(forKey: "ach5") == nil && matrix.isEmpty){
            defaults.set("1", forKey : "ach5")
            set = true
        }
        
        // used 10 bombs
        if (defaults.string(forKey: "ach6") == nil && bombCount >= 10){
            defaults.set("1", forKey : "ach6")
            set = true
        }
        
        // used 10 rainbows
        if (defaults.string(forKey: "ach7") == nil && rainbowCount >= 10){
            defaults.set("1", forKey : "ach7")
            set = true
        }
        
        // play achievements sound
        if (set) {
            soundEffect = SKAction.playSoundFileNamed("achievement.flac", waitForCompletion: false)
            self.run(soundEffect)
        }
    }
}


