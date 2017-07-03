//
//  aEstrella.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 20/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

class Astar {
    var closedSet: Set<Cell>!
    var openedSet: [Cell]!
    var cameFrom: [Cell:Cell] = [Cell:Cell]()
    var gScore: [Cell:Double]!
    var fScore: [Cell:Double]!
    var current: Cell
    var map: [[Cell]]
    
    init(map: [[Cell]]) {
        self.map = map
        self.current = Cell()
        self.closedSet = Set<Cell>()
        self.openedSet = [Cell]()
        self.fScore = [Cell:Double]()
        self.gScore = [Cell:Double]()
    }
    
    func getPath(start: Cell, goal: Cell) -> [Cell] {
        clean()
        
        for col in map {
            for c in col {
                self.gScore[c] = Double.infinity
                self.fScore[c] = Double.infinity
            }
        }
        
        gScore[start] = 0.0
        fScore[start] = heuristic_cost_estimate(from: start,to: goal)
        openedSet.append(start)

        while !openedSet.isEmpty {
            current = openedSet.first!
            
            if current == goal {
                return reconstruct_path(cameFrom: cameFrom, current: current)
            }
            
            openedSet.removeFirst()
            closedSet.insert(current)
            for each in neighborhood(map: map, centerCell: current) {
                if closedSet.contains(each) {
                    continue
                }
    
                let tenativeGScore = gScore[current]! + dist_between(current: current, next: each)
                if !openedSet.contains(each) {
                    openedSet.append(each)
                } else if tenativeGScore >= gScore[each]! {
                    continue
                }
                
                cameFrom[each] = current
                gScore[each] = tenativeGScore
                
                let estimatedFScore = gScore[each]! + heuristic_cost_estimate(from: each, to: goal)
                fScore[each] = estimatedFScore
                openedSet = openedSet.sorted(by: { (first: Cell, second: Cell) -> Bool in fScore[first]! < fScore[second]!})
            }
            
        }
        return [Cell]()
    }
    
    func reconstruct_path(cameFrom: [Cell:Cell], current: Cell) -> [Cell] {
        var totalPath:[Cell] = [Cell]()
        var c: Cell? = current
        
        while c != nil {
            let previous:Cell = c!
            c = cameFrom[c!]
            
            if c != nil {
                totalPath.append(previous)
            }
        }
        
        totalPath.reverse()
        return totalPath
    }
    
    func dist_between(current: Cell, next: Cell) -> Double {
        for edge in neighborhood(map: map, centerCell: current) {
            if edge == next {
                return 1.0 //edge.getCost();
            }
        }
        return Double.infinity;
    }
    
    func heuristic_cost_estimate(from: Cell, to: Cell) -> Double {
        return sqrt(Double(pow(to.col() - from.col(), 2) + pow(to.row() - from.row(), 2)))
    }
    
    func neighborhood(map: [[Cell]], centerCell: Cell) -> [Cell] {
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
    
    func getCell(aCell: Cell) -> Cell {
        return map[Int(aCell.position.x)][Int(aCell.position.y)]
    }
    
    func clean() {
        self.current = Cell()
        self.closedSet = Set<Cell>()
        self.openedSet = [Cell]()
        self.fScore = [Cell:Double]()
        self.gScore = [Cell:Double]()
        self.cameFrom = [Cell:Cell]()
    }
}
