//
//  MathCell.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 05/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation
import CoreGraphics

class MathCell {
    static func random(range: CountableClosedRange<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
    }
    
    static func dist_pointToPoint(from: CGPoint, to: CGPoint) -> Double {
        return sqrt(Double(pow(to.x - from.x, 2) + pow(to.y - from.y, 2)))
    }

    static func neighborhood(map: [[Cell]], centerCell: Cell) -> [Cell] {
        var neighbor:[Cell] = [Cell]()
        let x:Int = Int(centerCell.position.x)
        let y:Int = Int(centerCell.position.y)
        
        //LEFT
        if (x - 1 >= 0 && x - 1 < map.count) {
            if map[x - 1][y].isWalkable() {
                neighbor.append(map[x - 1][y])
            }
        }
        
        //UP
        if (y - 1 >= 0 && y - 1 < map[0].count) {
            if map[x][y - 1].isWalkable() {
                neighbor.append(map[x][y - 1])
            }
        }
        
        //RIGHT
        if (x + 1 >= 0 && x + 1 < map.count) {
            if map[x + 1][y].isWalkable() {
                neighbor.append(map[x + 1][y])
            }
        }
        
        //DOWN
        if (y + 1 >= 0 && y + 1 < map[0].count) {
            if map[x][y + 1].isWalkable() {
                neighbor.append(map[x][y + 1])
            }
        }
        
        return neighbor
    }
}
