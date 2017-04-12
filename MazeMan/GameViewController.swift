//
//  GameViewController.swift
//  MazeMan
//
//  Created by Jay Guan on 4/3/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.showsPhysics = false
        skView.presentScene(scene)
        print(scene.playerObject.coordinate?.x)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
