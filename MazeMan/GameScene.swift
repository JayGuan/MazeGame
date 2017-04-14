//
//  GameScene.swift
//  MazeMan
//
//  Created by Jay Guan on 4/3/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    var data = MiddleModel()
    var playerObject:Grid!
    var message = Message()
    var starLabel = SKLabelNode()
    var rockLabel = SKLabelNode()
    var energyLabel = SKLabelNode()
    var heartLabel = SKLabelNode()
    var ground = SKNode()
    var playerStats = Player()
    var itemSize = CGSize(width:64, height:64)
    var food: Grid!
    var star: Grid!
    var blockCount = 0
    var messageNode = SKLabelNode()
    var rockTimeCount = 0
    var timer:Timer?
    var foodTimeCount = -1
    var gravityCountDown = 0
    var characterMovementDuration = 5
    var enemySpawnTime = [Int]()
    var dinoSpeed = 180.0
    var playerSpeed = 150.0
    var rockSpeed = 200.0
    var dino4 = SKNode()
    var fireballTime = -1
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        playerObject = Grid()
        data.populateCoordinates()
        addCharacter(imgName: "app-icon", row: 5, column: 8, direction: "right")
        addPhysics()
        addBitMask()
        //addGround()
        addSides()
        populateBackground()
        populateMessage(message: message.welcomeMessage())
        populatePlayerStatus()
        initializeEnemySpawnTime()
        loadEnemies()
        //delete later
        generateGravityTime()
        generateFireBallTime()
        addMiddleItem(imgName: "block", width: 64, height: 64, row: 1, column: 11, zPosition: 1, scale: 1)
            addMiddleItem(imgName: "block", width: 64, height: 64, row: 1, column: 5, zPosition: 1, scale: 1)
        addMiddleItem(imgName: "food", width: 64, height: 64, row: 8, column: 7, zPosition: 1, scale: 1)
        addMiddleItem(imgName: "star", width: 64, height: 64, row: 7, column: 7, zPosition: 1, scale: 1)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        let shoot = UITapGestureRecognizer(target: self, action: #selector(shootFunction))
        self.view?.addGestureRecognizer(shoot)
    }
    
    func initializeEnemySpawnTime() {
        // 4 types of enemies
        for i in 0..<4 {
            enemySpawnTime.append(-1)
        }
    }
    
    func loadEnemies() {
        
        let waterBlockIndex = Int(arc4random_uniform(2))
        var dino1Position = 0
        if waterBlockIndex == 0 {
            dino1Position = 5
        }
        else {
            dino1Position = 11
        }
        let dino2Position = Int(arc4random_uniform(9)) + 1
        loadDino1(columnNum: dino1Position)
        loadDino2(rowNum: dino2Position)
        loadDino3()
        loadDino4()
    }
    
    func loadDino1(columnNum: Int) {
        addEnemy(imgName: "dino1", width: 64, height: 64, row: 0, column: columnNum, zPosition: 3, scale: 1)
        
    }

    func loadDino2(rowNum: Int) {
        addEnemy(imgName: "dino2", width: 64, height: 64, row: rowNum, column: 15, zPosition: 3, scale: 1)
    }
    
    func loadDino3() {
        addEnemy(imgName: "dino3", width: 64, height: 64, row: 9, column: 0, zPosition: 3, scale: 1)
    }
    
    func loadDino4() {
        addEnemy(imgName: "dino4", width: 64, height: 64, row: 10, column: 1, zPosition: 3, scale: 1)
    }
    
    func generateFireBall(dino4: SKNode) {
        let x = Int(dino4.position.x)
        addEnemy(imgName: "fire", width: 64, height: 64, row: 9, column: x/64, zPosition: 3, scale: 1 )
    }
    
    func addDino1Action(dino1: SKNode) {
        
        let action = SKAction.moveTo(y: 608, duration: 768/dinoSpeed)
        let action2 = SKAction.moveTo(y: 32, duration: 768/dinoSpeed)
        let waitTime = Int(arc4random_uniform(3)) + 1
        let waitAction = SKAction.wait(forDuration: TimeInterval(waitTime))
        var actionSequence = [SKAction]()
        actionSequence.append(action)
        actionSequence.append(waitAction)
        actionSequence.append(action2)
        actionSequence.append(waitAction)
        let action3 = SKAction.sequence(actionSequence)
        dino1.run(SKAction.repeatForever(action3))
    }
    
    func addDino2Action(dino2: SKNode) {
        let action = SKAction.moveTo(x: 30, duration: 1024/dinoSpeed)
        let action2 = SKAction.moveTo(x: 995, duration: 1024/dinoSpeed)
        let waitTime = Int(arc4random_uniform(3)) + 1
        let waitAction = SKAction.wait(forDuration: TimeInterval(waitTime))
        var actionSequence = [SKAction]()
        actionSequence.append(action)
        actionSequence.append(waitAction)
        actionSequence.append(action2)
        actionSequence.append(waitAction)
        let action3 = SKAction.sequence(actionSequence)
        dino2.run(SKAction.repeatForever(action3))
    }
    
    func addDino3Action(dino3: SKNode) {
        let moveLeft = SKAction.moveTo(x: 995, duration: 1024/dinoSpeed)
        let moveRight = SKAction.moveTo(x: 30, duration: 1024/dinoSpeed)
        let moveUp = SKAction.moveTo(y: 608, duration: 768/dinoSpeed)
        let moveDown = SKAction.moveTo(y: 32, duration: 768/dinoSpeed)
    }
    
    func addDino4Action(dino4: SKNode) {
        let action = SKAction.moveTo(x: 995, duration: 1024/dinoSpeed)
        let action2 = SKAction.moveTo(x: 30, duration: 1024/dinoSpeed)
        var actionSequence = [SKAction]()
        actionSequence.append(action)
        actionSequence.append(action2)
        let action3 = SKAction.sequence(actionSequence)
        dino4.run(SKAction.repeatForever(action3))
    }
    
    func addFireAction(fire: SKNode) {
        let action2 = SKAction.moveTo(y: -32, duration: 768/dinoSpeed)
        fire.run(action2)
    }
    
    func generateGravityTime() {
        gravityCountDown = 40 + Int(arc4random_uniform(20))
    }
    
    func generateFireBallTime() {
        fireballTime = Int(arc4random_uniform(5)) + 6
    }
    
    func updateTime() {
        playerStats.energy -= 1
        updateHealth()
        playerObject.content?.physicsBody?.affectedByGravity = false
        gravityCountDown -= 1
        if gravityCountDown == 3 {
            messageNode.text = "Gravity time is very close!"
        }
        if gravityCountDown == 0 {
            generateGravityTime()
            playerObject.content?.physicsBody?.affectedByGravity = true
            messageNode.text = message.welcomeMessage()
        }
        rockTimeCount += 1
        if rockTimeCount == 30 {
            rockTimeCount = 0
            if playerStats.rockNum < 20 {
                playerStats.rockNum += 1
                rockLabel.text = "\(playerStats.rockNum)"
            }
        }
        if foodTimeCount > -1 {
            foodTimeCount += 1
            if foodTimeCount == 10 {
                foodTimeCount = -1
                generateFood()
            }
        }
        fireballTime -= 1
        if fireballTime == 0 {
            generateFireBall(dino4: dino4)
            generateFireBallTime()
        }
    }
    
    func generateFood() {
        let position = getRandomAvailablePosition()
        addMiddleItem(imgName: "food", width: 64, height: 64, row: position.row, column: position.column, zPosition: 1, scale: 1)
    }
    
    func generateStar() {
        let position = getRandomAvailablePosition()
        addMiddleItem(imgName: "star", width: 64, height: 64, row: position.row, column: position.column, zPosition: 1, scale: 1)
    }
    
    func getRandomAvailablePosition() -> (row:Int, column:Int) {
        var found = false
        while !found {
            let row = Int(arc4random_uniform(9))+1
            let column = Int(arc4random_uniform(16))
            if data.contents[row][column].availability {
                return (row:row, column:column)
                found = true
            }
        }
    }
    
    func shootFunction(sender:UITapGestureRecognizer) {
        if playerStats.rockNum > 0 {
            if sender.state == .ended {
                let touchLocation = sender.location(in: sender.view)
                let convertedLocation = convertPoint(toView: touchLocation)
                let x1 = convertedLocation.x
                let y1 = convertedLocation.y
                let x2 = playerObject.content?.position.x
                let y2 = playerObject.content?.position.y
                let dx = x1-x2!
                let dy = y1-y2!
                let distance = sqrt(Double(dx*dx+dy*dy))
                print("x[\(touchLocation.x)]y[\(touchLocation.y)]")
                let vector = CGVector(dx:dx,dy:dy)
            
                let action = SKAction.repeatForever(SKAction.move(by: vector, duration: Double(abs(distance))/rockSpeed))
                
                let rock = SKSpriteNode(imageNamed: "rock")
                rock.name = "rock"
                rock.size = CGSize(width:60,height:60)
                rock.position = CGPoint(x:(playerObject.content?.position.x)!, y:(playerObject.content?.position.y)!)
                rock.zPosition = CGFloat(1)
                rock.scene?.scaleMode = SKSceneScaleMode.aspectFill
                rock.setScale(CGFloat(1))
                setRockPhysBody(rock: rock)
                self.addChild(rock)
                //add physics body
                rock.run(action)
                throwRock()
            }
        }
    }
    
    func throwRock() {
        playerStats.rockNum -= 1
        rockLabel.text = "\(playerStats.rockNum)"
    }
    
    func setRockPhysBody(rock: SKSpriteNode) {
        rock.physicsBody = SKPhysicsBody(rectangleOf: (playerObject.content!.size))
        rock.physicsBody?.allowsRotation = false
        rock.physicsBody?.affectedByGravity = false
        rock.physicsBody?.collisionBitMask = 0
        rock.physicsBody?.categoryBitMask = PhysicsCategory.Rock.rawValue
        rock.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue
    }
    
    func addStarCount() {
        playerStats.starNum += 1
        starLabel.text = "\(playerStats.starNum)"
    }
    
    func addPhysics(){
        playerObject.content?.physicsBody = SKPhysicsBody(rectangleOf: (playerObject.content!.size))
        playerObject.content?.physicsBody?.allowsRotation = false
        playerObject.content?.physicsBody?.affectedByGravity = false
        
    }
    
    func addBitMask() {
        playerObject.content?.physicsBody?.categoryBitMask = PhysicsCategory.Player.rawValue
        print("\(playerObject.content?.physicsBody?.categoryBitMask)")
        playerObject.content?.physicsBody?.contactTestBitMask = PhysicsCategory.Block.rawValue | PhysicsCategory.Enemy.rawValue
        playerObject.content?.physicsBody?.collisionBitMask = PhysicsCategory.Block.rawValue | PhysicsCategory.LeftEdge.rawValue | PhysicsCategory.RightEdge.rawValue
    }
    
    func handleSwipe(gesture: UIGestureRecognizer) {
        var action = SKAction()
        
        //calculate how far needs to move
        
        if let swipe = gesture as? UISwipeGestureRecognizer {
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                if playerStats.updateDirection(newDirection: "right") {
                    playerObject.content?.xScale = -1
                }
                action = SKAction.move(by: CGVector(dx: 1024, dy: 0), duration: 1024/playerSpeed)
                print("player :x[\(playerObject.content?.position.x)]y[\(playerObject.content?.position.y)]")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                action = SKAction.move(by: CGVector(dx: 0, dy: -1024), duration: 1024/playerSpeed)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                if playerStats.updateDirection(newDirection: "left") {
                    playerObject.content?.xScale = 1
                }
                action = SKAction.move(by: CGVector(dx: -1024, dy: 0), duration: 1024/playerSpeed)
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                action = SKAction.move(by: CGVector(dx: 0, dy: 1024), duration: 1024/playerSpeed)
            default:
                break
            }
        }

        playerObject.content?.run(action, withKey: "move")
        //playerObject.content?.position.x += 200
        print(playerObject.content?.position.x)
    }
    
    //facing right
    func addCharacter(imgName: String, row:Int, column:Int, direction: String) {
        let player = SKSpriteNode(imageNamed: imgName)
        if direction == "right" {
            player.xScale = -1
        }
        player.size = CGSize(width:60,height:60)
        player.name = "player"
        let x = data.coordinateByIndex(row: row, column: column).x
        let y = data.coordinateByIndex(row: row, column: column).y
        player.position = CGPoint(x: x, y: y)
        player.zPosition = 1
        self.addChild(player)
        playerObject.availability = false
        playerObject.content = player
        playerObject.itemName = imgName
        playerObject.coordinate = (x,y)
        data.contents[row][column] = playerObject
    }
    
    func populatePlayerStatus() {
        addItem(imgName: "star", width:64, height:64, xCoordinate: 32, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "rock", width:64, height:64, xCoordinate: 96, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "heart", width:64, height:64, xCoordinate: 160, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "battery", width:100, height:64, xCoordinate: 260, yCoordinate: 32,zPosition:1, scale:1.5)
        
        starLabel.text = "\(playerStats.starNum)"
        starLabel.fontSize = 25
        starLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        starLabel.fontColor = UIColor.white
        starLabel.position = CGPoint(x: 32, y: 20)
        starLabel.zPosition = 2
        self.addChild(starLabel)
        
        rockLabel.text = "\(playerStats.rockNum)"
        rockLabel.fontSize = 25
        rockLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        rockLabel.fontColor = UIColor.white
        rockLabel.position = CGPoint(x: 96, y: 20)
        rockLabel.zPosition = 2
        self.addChild(rockLabel)
        
        heartLabel.text = "\(playerStats.getLife())"
        heartLabel.fontSize = 25
        heartLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        heartLabel.fontColor = UIColor.white
        heartLabel.position = CGPoint(x: 160, y: 20)
        heartLabel.zPosition = 2
        self.addChild(heartLabel)
        
        energyLabel.text = "\(playerStats.getEnergy())"
        energyLabel.fontSize = 25
        energyLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        energyLabel.fontColor = UIColor.white
        energyLabel.position = CGPoint(x: 260, y: 20)
        energyLabel.zPosition = 2
        self.addChild(energyLabel)
    }
    
    func populateMessage(message:String) {
        print("Message is: \(message)")
        let statusPanel = SKSpriteNode(imageNamed: "game-status-panel")
        statusPanel.xScale = -1
        statusPanel.size = CGSize(width:900,height:120)
        // posiiton as center
        statusPanel.position = CGPoint(x: 500, y: 702)
        statusPanel.zPosition = 2
        self.physicsWorld.contactDelegate = self
        
        messageNode = SKLabelNode(text: message)
        messageNode.fontSize = 32
        messageNode.fontName = UIFont.boldSystemFont(ofSize: 32).familyName
        messageNode.fontColor = UIColor.white
        messageNode.position = CGPoint(x: 500, y: 702)
        messageNode.zPosition = 3
        
        self.addChild(statusPanel)
        self.addChild(messageNode)
    }
    
    //items do not change
    func populateBackground() {
        //buttom
        for i in 0...15 {
            if i == 5 || i == 11 {
                addItem(imgName: "water", width:64, height:50, xCoordinate:i*64+32, yCoordinate:32,zPosition:0, scale:1)
            }
            else {
                addItem(imgName: "block", width:64, height:64, xCoordinate:i*64+32, yCoordinate:32,zPosition:0, scale:1)
            }
        }
        //top
        for i in 0...15 {
            addItem(imgName: "block", width:64, height:64, xCoordinate:i*64+32, yCoordinate:734,zPosition:0, scale:1)
        }
        for i in 0...15 {
            addItem(imgName: "block", width:64, height:64, xCoordinate:i*64+32, yCoordinate:670,zPosition:0, scale:1)
        }
    }
    
    func addItem(imgName: String, width:Int, height:Int, xCoordinate:Int, yCoordinate:Int, zPosition:Int, scale:Double) {
        let block = SKSpriteNode(imageNamed: imgName)
        block.size = CGSize(width:width,height:height)
        block.position = CGPoint(x:xCoordinate, y:yCoordinate)
        block.zPosition = CGFloat(zPosition)
        block.scene?.scaleMode = SKSceneScaleMode.aspectFill
        block.setScale(CGFloat(scale))
        self.physicsWorld.contactDelegate = self
        
        if imgName == "block" {
            block.name = "block"
            block.physicsBody = SKPhysicsBody(rectangleOf: playerObject.content!.size)
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block.rawValue
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
            block.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
        }
        else if imgName == "water" {
            block.name = "water"
            var waterSize = playerObject.content!.size
            waterSize.height = 50
            block.physicsBody = SKPhysicsBody(rectangleOf: waterSize)
            block.physicsBody?.categoryBitMask = PhysicsCategory.Water.rawValue
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.isDynamic = false
        }
        
        self.addChild(block)
    }
    
    func addMiddleItem(imgName: String, width:Int, height:Int, row:Int, column:Int, zPosition:Int, scale:Double) {
        if data.contents[row][column].availability {
            let item = Grid()
            item.availability = false
            let xCoordinate = data.coordinateByIndex(row: row, column: column).x
            let yCoordinate = data.coordinateByIndex(row: row, column: column).y
            item.coordinate = (xCoordinate, yCoordinate)
            item.itemName = imgName
            data.contents[row][column] = item
            
            let itemNode = SKSpriteNode(imageNamed: imgName)
            itemNode.size = CGSize(width:width,height:height)
            itemNode.position = CGPoint(x:xCoordinate, y:yCoordinate)
            itemNode.zPosition = CGFloat(zPosition)
            itemNode.scene?.scaleMode = SKSceneScaleMode.aspectFill
            itemNode.setScale(CGFloat(scale))
            switch imgName {
            case "block":
                setBlockPhysBody(item: itemNode)
            case "food":
                setFoodPhysBody(item: itemNode)
                food = item
            default:
                setStarPhysBody(item: itemNode)
                star = item
            }
            
            self.addChild(itemNode)
            item.content = itemNode
            
        }
        else {
            print("block is not available")
        }
    }
    
    func setBlockPhysBody(item: SKSpriteNode) {
        item.name = "block"
        item.physicsBody = SKPhysicsBody(rectangleOf: playerObject.content!.size)
        item.physicsBody?.categoryBitMask = PhysicsCategory.Block.rawValue
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
        item.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.isDynamic = false
    }
    
    func setFoodPhysBody(item: SKSpriteNode) {
        item.name = "food"
        item.physicsBody = SKPhysicsBody(rectangleOf: itemSize)
        item.physicsBody?.categoryBitMask = PhysicsCategory.Food.rawValue
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Enemy.rawValue
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.isDynamic = false
        
    }
    
    
    func setStarPhysBody(item: SKSpriteNode) {
        item.name = "star"
        item.physicsBody = SKPhysicsBody(rectangleOf: itemSize)
        item.physicsBody?.categoryBitMask = PhysicsCategory.Star.rawValue
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
        item.physicsBody?.affectedByGravity = false
        item.physicsBody?.isDynamic = false
        
    }
    
    func addEnemy(imgName: String, width:Int, height:Int, row:Int, column:Int, zPosition:Int, scale:Double) {
        let enemy = Enemy.init(name: imgName)
        var pass = false
        if imgName == "dino4" {
            pass = true
        }
        if data.contents[row][column].availability || pass {
            let item = Grid()
            item.availability = false
            var xCoordinate = data.coordinateByIndex(row: row, column: column).x
            var yCoordinate = data.coordinateByIndex(row: row, column: column).y
            item.coordinate = (xCoordinate, yCoordinate)
            item.itemName = imgName
            data.contents[row][column] = item
            
            let monsters = SKSpriteNode(imageNamed: imgName)
            if imgName == "dino4" {
                monsters.size = CGSize(width:width*2,height:height)
                yCoordinate = 680
                print("dino4 y[\(yCoordinate)]")
            }
            else {
                monsters.size = CGSize(width:width,height:height)
            }
            monsters.position = CGPoint(x:xCoordinate, y:yCoordinate)
            monsters.zPosition = CGFloat(zPosition)
            monsters.scene?.scaleMode = SKSceneScaleMode.aspectFill
            monsters.setScale(CGFloat(scale))
            if imgName == "dino3" {
                setPhysBodyCollideBlocks(node: monsters)
            }
            else {
                setPhysBodyThroughBlocks(node: monsters)
            }
            monsters.name = imgName
            self.addChild(monsters)
            switch imgName {
            case "dino1":
                addDino1Action(dino1: monsters)
                print("dino1 y[\(yCoordinate)]")
            case "dino2":
                addDino2Action(dino2: monsters)
            case "dino3":
                break
            case "dino4":
                dino4 = monsters
                print("dino4 y coor[\(monsters.position.y)]")
                addDino4Action(dino4: monsters)
            case "fire":
                addFireAction(fire: monsters)
            default:
                break
            }
        }
        else {
            print("block is not available")
        }
    }
    
    func setPhysBodyThroughBlocks(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: (playerObject.content!.size))
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Block.rawValue | PhysicsCategory.Player.rawValue | PhysicsCategory.Rock.rawValue | PhysicsCategory.LeftEdge.rawValue | PhysicsCategory.RightEdge.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Ground.rawValue
    }
    
    func setPhysBodyCollideBlocks(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: (playerObject.content!.size))
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Block.rawValue | PhysicsCategory.Player.rawValue | PhysicsCategory.Rock.rawValue | PhysicsCategory.LeftEdge.rawValue | PhysicsCategory.RightEdge.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.Block.rawValue | PhysicsCategory.Player.rawValue | PhysicsCategory.Ground.rawValue
    }
    
    func updateHealth() {
        energyLabel.text = "\(playerStats.getEnergy())"
        heartLabel.text = "\(playerStats.getLife())"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact did begin")
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask
        
        //if Player contacted something
        if contactA == PhysicsCategory.Player.rawValue {
            switch contactB {
            case PhysicsCategory.Enemy.rawValue:
                reduceEnergy(enemyName: (contact.bodyB.node?.name)!)
                playerObject.content?.removeAction(forKey: "move")
                updateHealth()
            case PhysicsCategory.Water.rawValue:
                print("water contacted")
                playerStats.energy = 0
                playerStats.dead = true
                updateHealth()
                //TODO gameover
            case PhysicsCategory.Food.rawValue:
                if playerStats.energy + 50 < 300 {
                    playerStats.energy += 50
                }
                else {
                    playerStats.energy = 300
                }
                updateHealth()
                food.content?.removeFromParent()
                generateFood()
            case PhysicsCategory.Star.rawValue:
                addStarCount()
                messageNode.text = "Bravo, you've got the star"
                star.content?.removeFromParent()
                generateStar()
            default:
                break
            }
        }
        else if contactB == PhysicsCategory.Player.rawValue {
            switch contactA {
            case PhysicsCategory.Enemy.rawValue:
                reduceEnergy(enemyName: (contact.bodyA.node?.name)!)
                playerObject.content?.removeAction(forKey: "move")
                populatePlayerStatus()
            case PhysicsCategory.Water.rawValue:
                playerStats.energy = 0
                playerStats.dead = true
                populatePlayerStatus()
            case PhysicsCategory.Food.rawValue:
                if playerStats.energy + 50 < 300 {
                    playerStats.energy += 50
                }
                else {
                    playerStats.energy = 300
                }
                updateHealth()
                food.content?.removeFromParent()
                generateFood()
            case PhysicsCategory.Star.rawValue:
                addStarCount()
                messageNode.text = "Bravo, you've got the star"
                star.content?.removeFromParent()
                generateStar()
            //TODO gameover
            default:
                break
            }
        }
        // Enemy contacts food
        else if contactA == PhysicsCategory.Enemy.rawValue && contactB == PhysicsCategory.Food.rawValue
             {
                // enemy eats food
            if contact.bodyA.node?.name == "dino1" ||
                contact.bodyA.node?.name == "dino2" ||
                contact.bodyA.node?.name == "dino3" {
                foodTimeCount = 0
                food.content?.removeFromParent()
                }
            
        }
        else if contactB == PhysicsCategory.Enemy.rawValue && contactA == PhysicsCategory.Food.rawValue {
            // enemy eats food
            if contact.bodyB.node?.name == "dino1" ||
                contact.bodyB.node?.name == "dino2" ||
                contact.bodyB.node?.name == "dino3" {
                foodTimeCount = 0
                food.content?.removeFromParent()
            }
        }
        else if contactA == PhysicsCategory.Enemy.rawValue && contactB == PhysicsCategory.RightEdge.rawValue {
            contact.bodyA.node?.xScale = 1
            print("contacted edge, turn")
        }
        else if contactA == PhysicsCategory.Enemy.rawValue && contactB == PhysicsCategory.LeftEdge.rawValue {
            contact.bodyA.node?.xScale = -1
            print("contacted edge, turn")
        }
        else if contactB == PhysicsCategory.Enemy.rawValue && contactA == PhysicsCategory.RightEdge.rawValue {
            contact.bodyB.node?.xScale = 1
            print("contacted edge, turn")
        }
        else if contactB == PhysicsCategory.Enemy.rawValue && contactA == PhysicsCategory.LeftEdge.rawValue {
            contact.bodyB.node?.xScale = -1
            print("contacted edge, turn")
        }
        // Rock contacts
        else if contactA == PhysicsCategory.Rock.rawValue && contactB == PhysicsCategory.Enemy.rawValue {
            if contact.bodyB.node?.name == "dino1" ||
                contact.bodyB.node?.name == "dino2" ||
                contact.bodyB.node?.name == "dino3" ||
            contact.bodyB.node?.name == "fire" {
            let name = contact.bodyB.node?.name!
            messageNode.text = "\(name!) killed"
            contact.bodyB.node?.removeFromParent()
            contact.bodyA.node?.removeFromParent()
            }
        }
        else if contactB == PhysicsCategory.Rock.rawValue && contactA == PhysicsCategory.Enemy.rawValue{
            if contact.bodyA.node?.name == "dino1" ||
                contact.bodyA.node?.name == "dino2" ||
                contact.bodyA.node?.name == "dino3" ||
                contact.bodyA.node?.name == "fire" {
            let name = contact.bodyA.node?.name!
            messageNode.text = "\(name!) killed"
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            }
        }
    }
    
    func reduceEnergy(enemyName: String) {
        var energy = playerStats.energy
        
        switch enemyName {
        case "dino1":
            energy-=60
        case "dino2":
            energy-=80
        case "dino3":
            energy-=100
        case "fire":
            energy-=100
        default:
            energy-=0
        }
        if energy < 0 {
            playerStats.energy = 0
            //TODO call gameover
        }
        else {
            playerStats.energy = energy
        }
    }
    
    //TEST
    func addGround(){
        
        ground.position = CGPoint(x: 32, y: 32)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2*self.frame.width, height: 64))
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground.rawValue
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Enemy.rawValue
        //ground.physicsBody?.collisionBitMask = PhysicsCategory.Enemy.rawValue
        ground.physicsBody?.isDynamic = false
        addChild(ground)
 
    }
    
    func addSides() {
        let leftSide = SKNode()
        leftSide.position = CGPoint(x: 0, y: 0)
        leftSide.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 2*self.frame.height))
        leftSide.physicsBody?.categoryBitMask = PhysicsCategory.LeftEdge.rawValue
        leftSide.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Enemy.rawValue
        leftSide.physicsBody?.isDynamic = false
        addChild(leftSide)
        
        let rightSide = SKNode()
        rightSide.position = CGPoint(x: 1024, y: 0)
        rightSide.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 2*self.frame.height))
        rightSide.physicsBody?.categoryBitMask = PhysicsCategory.RightEdge.rawValue
        rightSide.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Enemy.rawValue
        rightSide.physicsBody?.isDynamic = false
        addChild(rightSide)
        
        let top = SKNode()
        top.position = CGPoint(x: 32, y: 672)
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2*self.frame.width, height: 64))
        top.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Enemy.rawValue
        top.physicsBody?.isDynamic = false
        addChild(top)
    }
    
    enum PhysicsCategory: UInt32 {
        case Block = 1
        case Player = 2
        case Ground = 4
        case Enemy = 8
        case Water = 16
        case Food = 32
        case Star = 64
        case Rock = 128
        case LeftEdge = 256
        case RightEdge = 512
    }
}
