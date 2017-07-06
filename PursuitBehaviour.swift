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
    static func pursuit(start: Cell, goal: Cell, astar: Astar) -> [Cell] {
        
        if goal == start {
            return [Cell]()
        }
        
        var pathToPlayer:[Cell] = astar.getPath(start: start, goal: goal)
        pathToPlayer.removeLast() // remuevo la cell en la que esta ubicado el personaje,
                                  // no tengo que pisarlo, sino estar al lado.
        
        return pathToPlayer
    }
    
    //    static let MAX_VELOCITY:CGFloat = CGFloat(40)
    //    static let MAX_FORCE:CGFloat = CGFloat(40)
    //    static let MAX_SPEED:CGFloat = CGFloat(40)
    //
    //
    //    static func pursuit(entity: Cell, target: Cell, targetPlayer: Player) -> CGVector {
    //        let distance:CGPoint = target.point - entity.point
    //        let T:CGFloat = distance.length()/MAX_VELOCITY
    //        let futurePosition:CGPoint = target.point + (targetPlayer.physicsBody?.velocity)! * T
    //
    //        return seek(fromPosition: entity.point, futurePosition: futurePosition, velocityPlyer: (targetPlayer.physicsBody?.velocity)!)
    //    }
    //
    //    static func seek(fromPosition: CGPoint, futurePosition: CGPoint, velocityPlyer: CGVector) -> CGVector {
    //        var auxValue:CGPoint = futurePosition - fromPosition
    //        let desired_velocity:CGPoint = auxValue.normalize() * MAX_VELOCITY
    //        let vpVector:CGVector = CGVector(dx: desired_velocity.x, dy: desired_velocity.y)
    //        return vpVector
    //    }
    
}

