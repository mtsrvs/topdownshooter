//
//  Map.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 20/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation

import GameplayKit
import SpriteKit


class GameMap {
    
    static let row:Int = 22
    static let col:Int = 12
    let cellY:CGFloat
    let cellX:CGFloat
    var matrix : [[Cell]] = [[Cell]]()

    init(size: CGSize) {
        cellX = (size.width/CGFloat(GameMap.col))
        cellY = (size.height/CGFloat(GameMap.row))

        for i in 0 ..< GameMap.col {
            matrix.append([Cell]())
            for j in 0 ..< GameMap.row {
                let r: CGFloat = cellY/2.0 + cellY * CGFloat(j)
                let c: CGFloat = cellX/2.0 + cellX * CGFloat(i)
                matrix[i].append(Cell(position:CGPoint(x:i,y:j), row: r, col: c))
            }
        }
        
        //Walls
        matrix[0][0].setWalkable(status: false)
        matrix[0][1].setWalkable(status: false)
        matrix[0][2].setWalkable(status: false)

        matrix[5][2].setWalkable(status: false)
        matrix[6][2].setWalkable(status: false)
        matrix[7][2].setWalkable(status: false)
        matrix[9][2].setWalkable(status: false)
    }
    
    func getMap() -> [[Cell]] {
        return self.matrix
    }
    
    func pointToCell(point: CGPoint) -> Cell {
        var value:CGFloat = point.y/cellY
        let rowCell:Int = Int(value.rounded(.down))
        value = point.x/cellX
        let colCell:Int = Int(value.rounded(.down))
        
        if(outOfBounds(row: rowCell, col: colCell)) {
            return Cell()
        }
        
        return matrix[colCell][rowCell]
    }

    func outOfBounds(row: Int, col: Int) -> Bool {
        if row < 0 || row >= GameMap.row {
            return true
        }
        
        if col < 0 || col >= GameMap.col {
            return true
        }
        
        return false
    }
}
