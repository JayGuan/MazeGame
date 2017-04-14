//
//  Player.swift
//  MazeMan
//
//  Created by Jay Guan on 4/3/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class Player {
    var energy = 300
    var direction:String = ""
    var rockNum = 10
    var dead = false
    var gravity = false
    var starNum = 0
    
    func getLife() -> Int {
        return energy/100
    }
    
    func getEnergy() ->Int {
        if energy%100 == 0 {
            // when % 100 == 0 energy can be 0 or 100
            if energy == 0 {
                return 0
            }
            else {
                return 100
            }
        }
        return energy%100
    }
    
    func updateDirection(newDirection: String) -> Bool {
        if direction == newDirection {
            return false
        }
        direction = newDirection
        return true
    }
}
