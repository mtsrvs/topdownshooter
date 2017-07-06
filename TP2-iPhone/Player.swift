//
//  Player.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 20/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    let bodyRectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    weak var gameScene: GameScene!
    var myPath:[Cell]!
    var nextCell:Cell!
    let VELOCITY:CGFloat = 2
    
    var myCell:Cell!
    var life:Int!
    var hasSword:Bool!
    var isDead:Bool!
    var timeAttack:Date!
    
    var hasArrived:Bool! = false

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(maxLife: Int) {
        let texture = SKTexture(imageNamed: "up")
        super.init(texture: texture, color: UIColor.red, size: texture.size())
        self.myPath = [Cell]()
        self.hasSword = false
        self.isDead = false
        self.hasArrived = true
        self.life = maxLife
        self.timeAttack = Date()
    }
    
    func setCell(c: Cell) {
        self.myCell = c
        self.nextCell = c
        self.position = c.point
    }
        
    func walkPath(pathToWalk: [Cell]) {
        self.myPath = pathToWalk
    }

    func move() {
        if isDead {
            self.deadTexture()
            return
        }
        
        if( myPath.isEmpty && hasArrived) {
            return
        }
        
        if hasArrived {
            nextCell = myPath.first
            myPath.removeFirst()
            hasArrived = false
        }

        let dir:CGPoint = direction(from: myCell.position, to: nextCell.position)
        let auxx = self.position.x + dir.x * VELOCITY
        let auxy = self.position.y + dir.y * VELOCITY
        let auxPoint = CGPoint(x: auxx, y: auxy)
        
        if MathCell.dist_pointToPoint(from: nextCell.point, to: auxPoint) > 1 {
            let dir:CGPoint = direction(from: myCell.position, to: nextCell.position)
            self.position.x = self.position.x + dir.x * VELOCITY
            self.position.y = self.position.y + dir.y * VELOCITY
            self.updateTexture(dir: dir)
        } else {
            self.myCell = nextCell
            self.position = nextCell.point
                
            if nextCell.hasItem() {
                self.hasSword = true
                nextCell.getItem().removeFromParent()
            }
            hasArrived = true
        }
    }
    
    func attack(map:[[Cell]], enemies: [Zombie]) {
        let nbh = MathCell.neighborhood(map: map, centerCell: self.myCell)
        let currentDate = Date()
        let elapsed = currentDate.timeIntervalSince(timeAttack)
        
        if(!hasSword || isDead) {
            return
        }
        
        for en in enemies {
            for n in nbh {
                if !en.isDead && MathCell.dist_pointToPoint(from: en.position, to: n.point) < 40 {
                    if elapsed > 1 { //ataca cada 1 segundo
                        timeAttack = currentDate
                        en.damage()
                    }
                }
            }
        }
    }
    
    func direction(from: CGPoint, to:CGPoint) ->CGPoint {
        if from.y < to.y  && from.x == to.x {
            return CGPoint(x: 0, y: 1)
        }
        if from.y > to.y  && from.x == to.x {
            return CGPoint(x: 0, y: -1)
        }
        
        if from.x < to.x  && from.y == to.y {
            return CGPoint(x: 1, y: 0)
        }
        if from.x > to.x  && from.y == to.y {
            return CGPoint(x: -1, y: 0)
        }
        
        return CGPoint.zero
    }
    
    func deadTexture() {
        self.texture = SKTexture(imageNamed: "dead")
    }
    
    func updateTexture(dir: CGPoint) {
        if dir.x < 0 {
            self.texture = SKTexture(imageNamed: "left")
        }

        if dir.x > 0 {
            self.texture = SKTexture(imageNamed: "right")
        }

        if dir.y < 0 {
            self.texture = SKTexture(imageNamed: "down")
        }
        
        if dir.y > 0 {
            self.texture = SKTexture(imageNamed: "up")
        }
    }

    func damage() {
        life = life - 1
        
        if life <= 0 {
            isDead = true
        }
    }
    
//    func dist_pointToPoint(from: CGPoint, to: CGPoint) -> Double {
//        return sqrt(Double(pow(to.x - from.x, 2) + pow(to.y - from.y, 2)))
//    }
    
//    func moveWander(playerCell: Cell, wanderResult: CGVector) {
//        
//        if canWander {
//            previousPlayerCell = playerCell
//            var steering:CGVector = wanderResult
//            steering = steering.truncate(value: 20)//max_force)
//            steering = steering / 1 //mass
//            
//            let aux:CGVector = (self.physicsBody?.velocity)! + steering
//            self.physicsBody?.velocity = aux.truncate(value: 20) //max_speed)
//            canWander = false
//        }
//    }
    
//    func isOtherPosition(otherCell: Cell) {
//        if previousPlayerCell != otherCell {
//            if MathCell.dist_pointToPoint(from: self.position, to: otherCell.point) < 0.5 {
//                self.physicsBody?.velocity = CGVector(dx:0, dy:0)
//                canWander = true
//            }
//        }
//    }

    //    func move() {
    //        if(!myPath.isEmpty || !inGoal) {
    //
    //            if hasArrived {
    //                previousPlayerCell = self.myCell
    //                nextCell = myPath.first
    //                myPath.removeFirst()
    //                hasArrived = false
    //            }
    //
    ////            print(dist_pointToPoint(from: nextCell.point, to: self.position))
    //            let dir:CGPoint = direction(from: previousPlayerCell.position, to: nextCell.position)
    //            if MathCell.dist_pointToPoint(from: nextCell.point, to: self.position) > 1 {
    //                self.position.x = self.position.x + dir.x * VELOCITY
    //                self.position.y = self.position.y + dir.y * VELOCITY
    //                self.updateTexture(dir: dir)
    //
    //            } else {
    //                self.myCell = nextCell
    //                hasArrived = true
    //
    //                if !myPath.isEmpty {
    //                    inGoal = true
    //                }
    //            }
    //        }
    //    }
    
    //    func move() {
    //        if(!myPath.isEmpty) {
    //
    //            if nextPos {
    //                nextPosition = myPath.first!.point
    //                nextPos = false
    //            }
    //
    //
    //            if dist_pointToPoint(from: nextPosition, to: self.position) > 0.5 {
    //                self.physicsBody?.velocity = CGVector(dx: ((myPath.first?.point.x)! - self.position.x) * VELOCITY,
    //                                                      dy: ((myPath.first?.point.y)! - self.position.y) * VELOCITY)
    //            } else {
    //                nextPos = true
    //                myPath.removeFirst()
    //            }
    //        } else {
    //            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    //        }
    //
    //    }
    
    //    func updateTexture() {
    //        let velx:CGFloat = (self.physicsBody?.velocity.dx)!
    //        let vely:CGFloat = (self.physicsBody?.velocity.dy)!
    //
    //        if !myPath.isEmpty {
    //            if abs(velx) < abs(vely) {
    //                if( vely < 0) {
    //                    self.texture = SKTexture(imageNamed: "down")
    //                } else {
    //                    self.texture = SKTexture(imageNamed: "up")
    //                }
    //            } else
    //                if( velx < 0) {
    //                    self.texture = SKTexture(imageNamed: "left")
    //                } else {
    //                    self.texture = SKTexture(imageNamed: "right")
    //            }            
    //        }
    //    }

}
