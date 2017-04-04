//
//  MiddleModel.swift
//  MazeMan
//
//  Created by Jay Guan on 4/4/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class MiddleModel {
    var contents = [[(x:Int, y:Int)]]()
    
    func populateCoordinates() {
        // each row
        for i in 2..<11{
            let newRow = [(x: Int, y: Int)]()
            contents.append(newRow)
            //each column
            for j in 0..<16 {
                    let coordinate:(x:Int, y:Int) = (j*64+32, i*64+32)
                    contents[i].append(coordinate)
            }
        }
    }
    
    func calculateCoordinate() {
    
    }
}
