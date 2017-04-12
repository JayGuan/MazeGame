//
//  Enemy.swift
//  MazeMan
//
//  Created by Jay Guan on 4/12/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class Enemy {
    var damage = 0
    var canGoThroughBlock = false
    //direction will be either updown or leftright or all
    var direction = ""
    var name = ""
    var fireball = false
    
    //properties
    init(name: String) {
        self.name = name
        switch name {
        case "dino1":
            damage = 60
            direction = "updown"
            canGoThroughBlock = true
        case "dino2":
            damage = 80
            direction = "leftright"
            canGoThroughBlock = true
        case "dino3":
            damage = 100
            direction = "all"
        case "dino4":
            damage = 60
            direction = "leftright"
            canGoThroughBlock = true
            fireball = true
        default:
            break
        }
    }
}
