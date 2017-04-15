//
//  MiddleModel.swift
//  MazeMan
//
//  Created by Jay Guan on 4/4/17.
//  Copyright © 2017 Jay Guan. All rights reserved.
//

import Foundation

class MiddleModel {
    
    var contents = [[Grid]]()
    
    func populateCoordinates() {
        // each row
        for i in 0..<12{
            let newRow = [Grid]()
            contents.append(newRow)
            //each column
            for j in 0..<16 {
                    let coordinate:(x:Int, y:Int) = (j*64+32, i*64+96)
                    let grid = Grid()
                    grid.coordinate = coordinate
                    contents[i].append(grid)
            }
        }
    }
    /*
        sample outline for the middle layer in array format
        80 81 82...8 16
        ...
        10 11 12...1 16
        00 01 02...0 16
     */
    //return SK object or nil
    func itemByCoordinateIndex(rowNum:Int,colNum:Int) -> Grid? {
            return contents[rowNum][colNum]
    }
    
    func coordinateByIndex(row: Int, column:Int)->(x:Int, y:Int) {
        let coordinate:(x:Int, y:Int) = (column*64+32, row*64+32)
        return coordinate
    }
}
