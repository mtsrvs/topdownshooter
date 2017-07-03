//
//  Wall.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 21/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Wall: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Wall")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
}
