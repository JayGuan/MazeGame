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
    override func didMove(to view: SKView) {
        //populateBackground()
        var data = MiddleModel()
        data.populateCoordinates()
        for i in 2..<11{
            //each column
            for j in 0..<16 {
                let coordinate = data.contents[i][j]
                
                let block = SKSpriteNode(imageNamed: "water")
                block.size = CGSize(width:64,height:64)
                block.position = CGPoint(x:, y:)
                self.physicsWorld.contactDelegate = self
                self.addChild(block)
            }
        }
    }
    
    func populateBackground() {
        //buttom
        for i in 0...15 {
            if i == 5 || i == 11 {
                let block = SKSpriteNode(imageNamed: "water")
                block.size = CGSize(width:64,height:64)
                block.position = CGPoint(x:i*64+32, y:32)
                self.physicsWorld.contactDelegate = self
                self.addChild(block)
            }
            else {
                let block = SKSpriteNode(imageNamed: "block")
                block.size = CGSize(width:64,height:64)
                block.position = CGPoint(x:i*64+32, y:32)
                self.physicsWorld.contactDelegate = self
                self.addChild(block)
            }
        }
        //top
        for i in 0...15 {
            let block = SKSpriteNode(imageNamed: "block")
            block.size = CGSize(width:64,height:64)
            block.position = CGPoint(x:i*64+32, y:734)
            self.physicsWorld.contactDelegate = self
            self.addChild(block)
        }
        for i in 0...15 {
            let block = SKSpriteNode(imageNamed: "block")
            block.size = CGSize(width:64,height:64)
            block.position = CGPoint(x:i*64+32, y:670)
            self.physicsWorld.contactDelegate = self
            self.addChild(block)
        }
    }
}
