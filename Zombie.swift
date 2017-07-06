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
    
    var mode:Int!
    
    let bodyRectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 10, height: 10))
    weak var gameScene: GameScene!
    var myPath:[Cell]!
    var nextCell:Cell!
    var myCell:Cell!
    
    let VELOCITY:CGFloat = 1

    var hasArrived:Bool! = false

    var life:Int!
    var isDead:Bool! = false
    var timeAttack:Date!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "enemydown")
        super.init(texture: texture, color: UIColor.red, size: texture.size())
        self.myPath = [Cell]()
        self.mode = EnemyConstants.WANDER_MODE
        self.hasArrived = true
        self.life = 5
        self.timeAttack = Date()
    }
    
    func setCell(c: Cell) {
        self.myCell = c
        self.nextCell = c
        self.position = c.point
    }
    

    func updateTexture(dir: CGPoint) {
        if dir.x < 0 {
            self.texture = SKTexture(imageNamed: "enemyleft")
        }
        
        if dir.x > 0 {
            self.texture = SKTexture(imageNamed: "enemyright")
        }
        
        if dir.y < 0 {
            self.texture = SKTexture(imageNamed: "enemydown")
        }
        
        if dir.y > 0 {
            self.texture = SKTexture(imageNamed: "enemyup")
        }
    }
    
    func deadTexture() {
        self.texture = SKTexture(imageNamed: "bloodenemy")
    }
    
    func checkMode(player: Cell) {
        if MathCell.dist_pointToPoint(from: player.point, to: self.myCell.point) > EnemyConstants.DISTANCE_PLAYER {
            self.mode = EnemyConstants.WANDER_MODE
        } else {
            self.mode = EnemyConstants.PURSIUT_MODE
        }
    }
    
    func walkPath(pathToWalk: [Cell]) {
        self.myPath = pathToWalk
    }
    
    func move() {
        if(isDead) {
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
            hasArrived = true
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
    
    func damage() {
        life = life - 1
        
        if life <= 0 {
            isDead = true
        }
    }
    
    func attack(player: Player) {
        let currentDate = Date()
        let elapsed = currentDate.timeIntervalSince(timeAttack)
        
        if isDead {
            return
        }
        
        if !player.isDead && MathCell.dist_pointToPoint(from: player.position, to: self.position) < 40 {
            if elapsed > 2 { //ataca cada 2 segundos
                timeAttack = currentDate
                player.damage()
            }
        }
    }
    
    //    func isOtherPosition(otherCell: Cell) -> Bool {
    //        if previousPlayerCell != otherCell {
    //            if MathCell.dist_pointToPoint(from: self.position, to: otherCell.point) < 0.5 {
    //                self.physicsBody?.velocity = CGVector.zero
    //                self.physicsBody?.applyForce(CGVector.zero)
    //                return true
    //            }
    //        }
    //        return false
    //    }
    
//    func continueWander(otherCell: Cell) -> Bool {
//        canWander = isOtherPosition(otherCell: otherCell)
//        return canWander
//    }
    
//    func continuePursuit(otherCell: Cell) -> Bool {
//        canPursuit = isOtherPosition(otherCell: otherCell)
//        return canPursuit
//    }
    
    
    //    func updateTexture(dir: CGPoint) {
    //
    //        if dir.x < 0 {
    //            self.texture = SKTexture(imageNamed: "enemyleft")
    //        }
    //
    //        if dir.x > 0 {
    //            self.texture = SKTexture(imageNamed: "enemyright")
    //        }
    //
    //        if dir.y < 0 {
    //            self.texture = SKTexture(imageNamed: "enemydown")
    //        }
    //
    //        if dir.y > 0 {
    //            self.texture = SKTexture(imageNamed: "enemyup")
    //        }
    //    }
    
    //    func updateTexture() {
    //        let velx:CGFloat = (self.physicsBody?.velocity.dx)!
    //        let vely:CGFloat = (self.physicsBody?.velocity.dy)!
    //
    //        if !myPath.isEmpty {
    //            if abs(velx) < abs(vely) {
    //                if( vely < 0) {
    //                    self.texture = SKTexture(imageNamed: "enemydown")
    //                } else {
    //                    self.texture = SKTexture(imageNamed: "enemyup")
    //                }
    //            } else
    //                if( velx < 0) {
    //                    self.texture = SKTexture(imageNamed: "enemyleft")
    //                } else {
    //                    self.texture = SKTexture(imageNamed: "enemyright")
    //            }
    //        }
    //    }
    
    //    func moveWander(playerCell: Cell, wanderResult: CGVector) {
    //
    //        if canWander {
    //            previousPlayerCell = playerCell
    //            var steering:CGVector = wanderResult
    //            steering = steering.truncate(value: 20)//max_force)
    //            steering = steering / 1 //mass
    //
    //            var aux:CGVector = (self.physicsBody?.velocity)! + steering
    //            self.physicsBody?.velocity = aux.truncate(value: 20) //max_speed)
    //            canWander = false
    //        }
    //    }
    
    //    func movePursuit(playerCell: Cell, steering: CGVector) {
    //        if canPursuit {
    //            previousPlayerCell = playerCell
    //
    //            var st:CGVector = steering
    //            st = st.truncate(value: 40)
    //            st = st / 1 // / mass
    //            self.physicsBody?.velocity = (self.physicsBody?.velocity)! + steering
    //            self.physicsBody?.velocity = (self.physicsBody?.velocity.truncate(value: 40))!
    //
    //            var velx:CGFloat = (self.physicsBody?.velocity.dx)!
    //            var vely:CGFloat = (self.physicsBody?.velocity.dy)!
    //
    //            if(abs(vely) > abs(velx)) {
    //                self.physicsBody?.velocity = CGVector(dx: 0, dy: vely)
    //            } else {
    //                self.physicsBody?.velocity = CGVector(dx: velx, dy: 0)
    //            }
    //            
    //            canPursuit = false
    //        }
    //    }
}
