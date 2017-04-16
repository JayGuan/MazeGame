//
//  GameOverScene.swift
//  MazeMan
//
//  Created by Jay Guan on 4/15/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    var highScores = [Int](repeating: 0, count: 3)
    init(size: CGSize, score: Int, highestScores: [Int]) {
        super.init(size: size)
        highScores = highestScores
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = ("Game Over")
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        self.addChild(gameOverLabel)
        
        let currentScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        currentScoreLabel.text = ("Current Score is \(score)")
        currentScoreLabel.fontSize = 40
        currentScoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        self.addChild(currentScoreLabel)
        
        let highScoreLable = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLable.text = ("Top 3 Scores: \(highestScores[0]), \(highestScores[1]), \(highestScores[2])")
        highScoreLable.fontSize = 30
        highScoreLable.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(highScoreLable)
        
        let playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.text = ("Tap to play again")
        playAgain.fontSize = 30
        playAgain.fontColor = UIColor.green
        playAgain.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        self.addChild(playAgain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.view?.addGestureRecognizer(tap)
    }
    
    func tapFunction() {
        let scene = GameScene(size: self.size, highestScores: self.highScores)
        self.view?.presentScene(scene)
    }
}
