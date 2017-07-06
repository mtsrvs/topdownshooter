//
//  Cell.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 20/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

class Cell: Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    var hashValue: Int {
        get {
            return self.point.hashValue
        }
    }
    
    var walkable:Bool
    var point:CGPoint
    var position:CGPoint
    var item:SKSpriteNode!
    
    init() {
        self.walkable = true
        self.position = CGPoint.zero
        self.point = CGPoint.zero
    }
    
    init(row: CGFloat, col: CGFloat, walkable: Bool) {
        self.walkable = walkable
        self.position = CGPoint.zero
        self.point = CGPoint(x:col, y:row)
    }

    init(position:CGPoint, row: CGFloat, col: CGFloat) {
        self.walkable = true
        self.position = position
        self.point = CGPoint(x:col, y:row)
    }
    
    init(row: CGFloat, col: CGFloat) {
        self.walkable = true
        self.position = CGPoint.zero
        self.point = CGPoint(x:col, y:row)
    }
    
    func setItem(item: SKSpriteNode) {
        self.item = item
    }

    func getItem() -> SKSpriteNode {
        return self.item
    }
    
    func hasItem() -> Bool {
        return self.item != nil
    }
    
    func setWalkable(status: Bool) {
        self.walkable = status
    }
    
    func isWalkable() -> Bool {
        return self.walkable
    }
    
    func pos() -> CGPoint {
        return self.position
    }
    
    func row() -> CGFloat {
        return point.y
    }
    
    func col() -> CGFloat {
        return point.x
    }
    
    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        return lhs.point == rhs.point
    }
}
