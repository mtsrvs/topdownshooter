//
//  WanderBehavior.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 02/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import Foundation
import CoreGraphics

class WanderBehaviour {
    let CIRCLE_DISTANCE:CGFloat = 5.0
    let CIRCLE_RADIUS:CGFloat = CGFloat(Double.pi/2)
    let ANGLE_CHANGE:CGFloat = CGFloat(Double.pi/2)
    var wanderAngle:CGFloat
    
    init() {
        self.wanderAngle = 0
    }
    
    func doWander(velocity:CGVector) -> CGVector {
        // Calculate the circle center
        var circleCenter:CGVector
        circleCenter = velocity.clone()
        circleCenter = circleCenter.normalize()
        circleCenter = circleCenter * CIRCLE_DISTANCE
        //
        // Calculate the displacement force
        var displacement :CGVector
        displacement = CGVector(dx: 0, dy: -1)
        displacement = displacement * CIRCLE_RADIUS
        //
        // Randomly change the vector direction
        // by making it change its current angle
        
        displacement = setAngle(vector: displacement, value: wanderAngle)
        //
        // Change wanderAngle just a bit, so it
        // won't have the same value in the
        // next game frame.
//        wanderAngle += CGFloat(arc4random()) * ANGLE_CHANGE - ANGLE_CHANGE * 0.5
        let randomValue:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        var auxVector:CGVector!
        
        if CGFloat(0) <= randomValue && randomValue <= CGFloat(0.25) {
            wanderAngle = CGFloat(0)
            auxVector = CGVector(dx: 1, dy: 0)
        } else if CGFloat(0.25) < randomValue && randomValue <= CGFloat(0.50) {
            wanderAngle = CGFloat(Double.pi/2)
            auxVector = CGVector(dx: 0, dy: 1)
        } else if CGFloat(0.50) < randomValue && randomValue <= CGFloat(0.75) {
            wanderAngle = CGFloat(Double.pi)
            auxVector = CGVector(dx: 1, dy: 0)
        } else if CGFloat(0.75) < randomValue && randomValue <= CGFloat(1.00) {
            wanderAngle = CGFloat(Double.pi * 1.5)
            auxVector = CGVector(dx: 0, dy: 1)
        }
        
        //
        // Finally calculate and return the wander force
        var wanderForce :CGVector
        wanderForce = circleCenter + displacement
//        wanderForce = setVector(vector: wanderForce, value: wanderAngle)
        return wanderForce
    }

    func setVector(vector:CGVector, value:CGFloat) -> CGVector {
        return CGVector(dx: cos(value) * vector.dx,dy: sin(value) * vector.dy)
    }
    
    func setAngle(vector:CGVector, value:CGFloat) -> CGVector {
        let len:CGFloat = vector.length()
        return CGVector(dx: cos(value) * len,dy: sin(value) * len)
    }
}
