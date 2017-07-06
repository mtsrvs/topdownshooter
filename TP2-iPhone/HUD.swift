//
//  HUD.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 03/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import SpriteKit
import GameplayKit

//esta clase muestra los datos del juego
class HUD {
    var lifeLabel:SKLabelNode?
    var heroLabel:SKLabelNode?
    var lifeLabelShadow:SKLabelNode?
    var heroLabelShadow:SKLabelNode?
    
    let maxLife:Int
    let offset:CGFloat = -2
    let size:CGSize
    
    init(cam: SKCameraNode, maxLife:Int, sksc: SKScene) {
        self.maxLife = maxLife
        self.size = sksc.size
        
        lifeLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        lifeLabel?.text = "Life \(maxLife) \\ \(maxLife)"
        lifeLabel?.fontColor = SKColor.white
        lifeLabel?.fontSize = 15
        lifeLabel?.zPosition = 1001
        lifeLabel?.position = CGPoint(x: cam.position.x + offset, y: cam.position.y - size.height/4 + offset)

        lifeLabelShadow = SKLabelNode(fontNamed: "Helvetica-Bold")
        lifeLabelShadow?.text = "Life \(maxLife) \\ \(maxLife)"
        lifeLabelShadow?.fontColor = SKColor.red
        lifeLabelShadow?.fontSize = 15
        lifeLabelShadow?.zPosition = 1000
        lifeLabelShadow?.position = CGPoint(x: cam.position.x + offset, y: cam.position.y - size.height/4 + offset)
        
        heroLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        heroLabel?.text = "HERO"
        heroLabel?.fontColor = SKColor.white
        heroLabel?.fontSize = 15
        heroLabel?.zPosition = 1001
        heroLabel?.position = CGPoint(x: cam.position.x + offset, y: cam.position.y - size.height/3 + offset)
        
        heroLabelShadow = SKLabelNode(fontNamed: "Helvetica-Bold")
        heroLabelShadow?.text = "HERO"
        heroLabelShadow?.fontColor = SKColor.red
        heroLabelShadow?.fontSize = 15
        heroLabelShadow?.zPosition = 1000
        heroLabelShadow?.position = CGPoint(x: cam.position.x + offset, y: cam.position.y - size.height/3 + offset)
        
        sksc.addChild(lifeLabel!)
        sksc.addChild(lifeLabelShadow!)
        sksc.addChild(heroLabel!)
        sksc.addChild(heroLabelShadow!)
    }
    
    func update(positionCam: CGPoint, playerLife: Int) {
        lifeLabel?.position = CGPoint(x: positionCam.x + offset, y: positionCam.y - size.height/4 + offset)
        lifeLabelShadow?.position = CGPoint(x: positionCam.x + offset, y: positionCam.y - size.height/4 + offset)
        heroLabel?.position = CGPoint(x: positionCam.x + offset, y: positionCam.y - size.height/3 + offset)
        heroLabelShadow?.position = CGPoint(x: positionCam.x + offset, y: positionCam.y - size.height/3 + offset)
        
        lifeLabel?.text = "Life \(playerLife) \\ \(maxLife)"
        lifeLabelShadow?.text = "Life \(playerLife) \\ \(maxLife)"
        
        if playerLife <= 0 {
            heroLabel?.text = "YOU ARE DEAD"
            heroLabelShadow?.text = "YOU ARE DEAD"
        }

    }
    
}
