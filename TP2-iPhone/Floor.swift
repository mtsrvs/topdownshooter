//
//  Floor.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 21/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import UIKit
import SpriteKit

class Floor: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Floor")
//        print(texture.size())
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 35, height: 35))
    }
    
}
