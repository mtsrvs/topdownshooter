//
//  PursuitBehaviour.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 02/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation
import CoreGraphics

class PursuitBehaviour {
    static let MAX_VELOCITY:CGFloat = CGFloat(1.0)
    static let MAX_FORCE:CGFloat = CGFloat(1.0)
    static let MAX_SPEED:CGFloat = CGFloat(1.0)

    
    static func pursuit(entity: Cell, target: Cell, targetPlayer: Player) -> CGVector {
        let distance:CGPoint = target.point - entity.point
        let T:CGFloat = distance.length()/MAX_VELOCITY
        let futurePosition:CGPoint = target.point + (targetPlayer.physicsBody?.velocity)! * T
        
        return seek(fromPosition: entity.point, futurePosition: futurePosition, velocityPlyer: (targetPlayer.physicsBody?.velocity)!)
    }
    
    static func seek(fromPosition: CGPoint, futurePosition: CGPoint, velocityPlyer: CGVector) -> CGVector {
        var vp:CGPoint = CGPoint(x: velocityPlyer.dx, y: velocityPlyer.dy)

        var auxValue:CGPoint = futurePosition - fromPosition
//        var auxValue:CGPoint = futurePosition - fromPosition
//        var velocity:CGPoint = auxValue.normalize() * MAX_VELOCITY

//        auxValue = futurePosition - fromPosition
        let desired_velocity:CGPoint = auxValue.normalize() * MAX_VELOCITY
        var steering:CGPoint = desired_velocity - vp
        
//        steering = steering.truncate(value: MAX_FORCE)
//        steering = steering / 1 // / mass
//        velocity = velocity + steering
//        velocity = velocity.truncate(value: MAX_SPEED)
        
//        var resul:CGPoint = futurePosition + velocity
//        var vpVector:CGVector = CGVector(dx: resul.x, dy: resul.y)
        
        var vpVector:CGVector = CGVector(dx: desired_velocity.x, dy: desired_velocity.y)
        return vpVector
    }
}

