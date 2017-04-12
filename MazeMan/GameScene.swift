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
    var playerObject = Grid()
    var message = Message()
    var starLabel = SKLabelNode()
    var rockLabel = SKLabelNode()
    var energyLabel = SKLabelNode()
    var heartLabel = SKLabelNode()
    var ground = SKNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        data.populateCoordinates()
        addCharacter(imgName: "app-icon", row: 5, column: 5, direction: "right")
        addBitMask()
        addPhysics()
        addGround()
        addSides()
        populateBackground()
        populateMessage(message: message.welcomeMessage())
        populatePlayerStatus()
        addEnemy(imgName: "dino1", width: 64, height: 64, row: 5, column: 8, zPosition: 1, scale: 1)
        /*
        addEnemy(imgName: "dino2", width: 64, height: 64, row: 8, column: 5, zPosition: 1, scale: 1)
        addEnemy(imgName: "dino3", width: 64, height: 64, row: 1, column: 5, zPosition: 1, scale: 1)
        addEnemy(imgName: "dino4", width: 64, height: 64, row: 5, column: 0, zPosition: 1, scale: 1)
 */
        playerObject.content?.physicsBody?.affectedByGravity = false
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
    }
    
    func addPhysics(){
        
        playerObject.content?.physicsBody = SKPhysicsBody(rectangleOf: (playerObject.content!.size))
        //ball.physicsBody?.isDynamic = false
    }
    
    func addBitMask() {
        playerObject.content?.physicsBody?.categoryBitMask = PhysicsCategory.Player.rawValue
        playerObject.content?.physicsBody?.collisionBitMask = PhysicsCategory.Block.rawValue
        playerObject.content?.physicsBody?.contactTestBitMask = PhysicsCategory.Block.rawValue
        //playerObject.content?.physicsBody?.isDynamic = false
        
    }
    
    func handleSwipe(gesture: UIGestureRecognizer) {
        var action = SKAction()
        
        //calculate how far needs to move
        
        if let swipe = gesture as? UISwipeGestureRecognizer {
            switch swipe.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                action = SKAction.move(by: CGVector(dx: 1024, dy: 0), duration: 5.0)
             
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                action = SKAction.move(by: CGVector(dx: 0, dy: -1024), duration: 5.0)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                action = SKAction.move(by: CGVector(dx: -1024, dy: 0), duration: 5.0)
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                action = SKAction.move(by: CGVector(dx: 0, dy: 1024), duration: 5.0)
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
        let block = SKSpriteNode(imageNamed: imgName)
        if direction == "right" {
            block.xScale = -1
        }
        block.size = CGSize(width:64,height:64)
        let x = data.coordinateByIndex(row: row, column: column).x
        let y = data.coordinateByIndex(row: row, column: column).y
        block.position = CGPoint(x: x, y: y)
        
        self.addChild(block)
        playerObject.availability = false
        playerObject.content = block
        playerObject.itemName = imgName
        playerObject.coordinate = (x,y)
        playerObject.content?.zPosition = 2
        data.contents[row][column] = playerObject
    }
    
    func populatePlayerStatus() {
        addItem(imgName: "star", width:64, height:64, xCoordinate: 32, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "rock", width:64, height:64, xCoordinate: 96, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "heart", width:64, height:64, xCoordinate: 160, yCoordinate: 32,zPosition:1, scale:1)
        addItem(imgName: "battery", width:100, height:64, xCoordinate: 260, yCoordinate: 32,zPosition:1, scale:1.5)
        
        starLabel.text = "0"
        starLabel.fontSize = 25
        starLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        starLabel.fontColor = UIColor.white
        starLabel.position = CGPoint(x: 32, y: 20)
        starLabel.zPosition = 2
        self.addChild(starLabel)
        
        rockLabel.text = "10"
        rockLabel.fontSize = 25
        rockLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        rockLabel.fontColor = UIColor.white
        rockLabel.position = CGPoint(x: 96, y: 20)
        rockLabel.zPosition = 2
        self.addChild(rockLabel)
        
        heartLabel.text = "3"
        heartLabel.fontSize = 25
        heartLabel.fontName = UIFont.boldSystemFont(ofSize: 20).familyName
        heartLabel.fontColor = UIColor.white
        heartLabel.position = CGPoint(x: 160, y: 20)
        heartLabel.zPosition = 2
        self.addChild(heartLabel)
        
        energyLabel.text = "100"
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
        
        let messageNode = SKLabelNode(text: message)
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
                addItem(imgName: "water", width:64, height:64, xCoordinate:i*64+32, yCoordinate:32,zPosition:0, scale:1)
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
            
            let block = SKSpriteNode(imageNamed: imgName)
            block.size = CGSize(width:width,height:height)
            block.position = CGPoint(x:xCoordinate, y:yCoordinate)
            block.zPosition = CGFloat(zPosition)
            block.scene?.scaleMode = SKSceneScaleMode.aspectFill
            block.setScale(CGFloat(scale))
            
            block.physicsBody = SKPhysicsBody(rectangleOf: playerObject.content!.size)
            block.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
            block.physicsBody?.categoryBitMask = PhysicsCategory.Block.rawValue
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
            block.physicsBody?.isDynamic = false
            block.physicsBody?.restitution = 0
            self.addChild(block)
            //TODO
            //add bitmask
            //DELETE later

        }
        else {
            print("block is not available")
        }
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
            let xCoordinate = data.coordinateByIndex(row: row, column: column).x
            let yCoordinate = data.coordinateByIndex(row: row, column: column).y
            item.coordinate = (xCoordinate, yCoordinate)
            item.itemName = imgName
            data.contents[row][column] = item
            
            let block = SKSpriteNode(imageNamed: imgName)
            block.size = CGSize(width:width,height:height)
            block.position = CGPoint(x:xCoordinate, y:yCoordinate)
            block.zPosition = CGFloat(zPosition)
            block.scene?.scaleMode = SKSceneScaleMode.aspectFill
            block.setScale(CGFloat(scale))
            
            block.physicsBody = SKPhysicsBody(rectangleOf: playerObject.content!.size)
            block.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
            block.physicsBody?.collisionBitMask = PhysicsCategory.Block.rawValue
            block.physicsBody?.contactTestBitMask = PhysicsCategory.Block.rawValue
            block.physicsBody?.restitution = 0
            block.physicsBody?.isDynamic = true
            self.addChild(block)
            
            let action = SKAction.move(by: CGVector(dx: 0, dy: 1024), duration: 7.0)
            block.run(action)
            //TODO
            //add bitmask
            //DELETE later
            
        }
        else {
            print("block is not available")
        }
        
    }
    
    func setPhysBodyThroughBlocks(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: playerObject.content!.size)
        node.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
        node.physicsBody?.categoryBitMask = PhysicsCategory.Block.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
    }
    
    func setPhysBodyCollideBlocks(node: SKSpriteNode) {
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact did begin")
        if contact.bodyA.categoryBitMask == PhysicsCategory.Player.rawValue && contact.bodyB.categoryBitMask == PhysicsCategory.Block.rawValue {
            print("player contacted block")
            
            playerObject.content?.removeAction(forKey: "move")
        }
        else if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy.rawValue && contact.bodyB.categoryBitMask == PhysicsCategory.Block.rawValue{
            print("enemy contacted block")
            
        }
        else {
            print("else")
        }
            /*
        else if contact.bodyB.categoryBitMask == PhysicsCategory.mario.rawValue || contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
            print("Mario contacted ball 2 ")
        }
 */
    }
    
    //TEST
    func addGround(){
        ground.position = CGPoint(x: 32, y: 32)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2*self.frame.width, height: 64))
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Block.rawValue
        ground.physicsBody?.isDynamic = false
        addChild(ground)
    }
    
    func addSides() {
        let leftSide = SKNode()
        leftSide.position = CGPoint(x: 0, y: 0)
        leftSide.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 2*self.frame.height))
        leftSide.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Block.rawValue
        leftSide.physicsBody?.isDynamic = false
        addChild(leftSide)
        
        let rightSide = SKNode()
        rightSide.position = CGPoint(x: 1024, y: 0)
        rightSide.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 2*self.frame.height))
        rightSide.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Block.rawValue
        rightSide.physicsBody?.isDynamic = false
        addChild(rightSide)
        
        let top = SKNode()
        top.position = CGPoint(x: 32, y: 672)
        top.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2*self.frame.width, height: 64))
        top.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Block.rawValue
        top.physicsBody?.isDynamic = false
        addChild(top)
    }
    
    enum PhysicsCategory: UInt32 {
        case Block = 1
        case Player = 2
        case Ground = 4
        case Enemy = 8
    }
}
