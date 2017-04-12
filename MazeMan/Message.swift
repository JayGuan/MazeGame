//
//  Message.swift
//  MazeMan
//
//  Created by Jay Guan on 4/3/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class Message {
    func welcomeMessage() -> String {
        return "Hello, Welcome to Mazeman!"
    }
    func enemyKilledMessage(enemyName: String) -> String {
        return "Enemy \(enemyName) killed!"
    }
    func starMessage() -> String {
        return "Bravo, you've got the star"
    }
    func gravityMessage() -> String {
        return "Gravity is coming in 3 seconds"
    }
}

