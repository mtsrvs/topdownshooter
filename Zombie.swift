//
//  Player.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 20/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Zombie: SKSpriteNode {
    
    let bodyRectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    weak var gameScene: GameScene!
    var myPath:[Cell]!
    var nextPosition:CGPoint!
    var canWander:Bool!
    var previousPlayerCell: Cell!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "CatDown1")
        super.init(texture: texture, color: UIColor.red, size: texture.size())
        self.physicsBody = SKPhysicsBody(polygonFrom: bodyRectangle.cgPath)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.myPath = [Cell]()
        self.canWander = true
        self.previousPlayerCell = Cell()
    }
    
    func dist_pointToPoint(from: CGPoint, to: CGPoint) -> Double {
        return sqrt(Double(pow(to.x - from.x, 2) + pow(to.y - from.y, 2)))
    }
    
    func moveWander(playerCell: Cell, wanderResult: CGVector) {
        
        if canWander {
            previousPlayerCell = playerCell
            var steering:CGVector = wanderResult
            steering = steering.truncate(value: 20)//max_force)
            steering = steering / 1 //mass
            
            var aux:CGVector = (self.physicsBody?.velocity)! + steering
            self.physicsBody?.velocity = aux.truncate(value: 20) //max_speed)
            canWander = false
        }
    }
    
    func isOtherPosition(otherCell: Cell) {
        if previousPlayerCell != otherCell {
            if dist_pointToPoint(from: self.position, to: otherCell.point) < 0.5 {
                self.physicsBody?.velocity = CGVector(dx:0, dy:0)
                canWander = true
            }
        }
    }
}
