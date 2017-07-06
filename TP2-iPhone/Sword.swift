//
//  Sword.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 03/07/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Sword: SKSpriteNode {
    var textureArray = [SKTexture]()
    weak var gameScene: GameScene!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "sword")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 35, height: 35))
    }
}
