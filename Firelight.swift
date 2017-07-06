//
//  Firelight.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 03/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Firelight: SKSpriteNode {
    var textureArray = [SKTexture]()
    weak var gameScene: GameScene!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let f1:SKTexture = SKTexture(imageNamed: "fire1")
        let f2:SKTexture = SKTexture(imageNamed: "fire2")
        let f3:SKTexture = SKTexture(imageNamed: "fire3")
        
        textureArray.append(f1)
        textureArray.append(f2)
        textureArray.append(f3)
        textureArray.append(f3)
        textureArray.append(f2)
        textureArray.append(f1)
        
        super.init(texture: f1, color: UIColor.clear, size: CGSize(width: 35, height: 35))
        self.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)))
    }
}
