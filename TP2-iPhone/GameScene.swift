//
//  GameScene.swift
//  TP2-iPhone
//
//  Created by Matias Rivas on 19/06/2017.
//  Copyright © 2017 itba. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let cam:SKCameraNode = SKCameraNode()

    var player:Player
    var zombie:Zombie
    var zombie2:Zombie
    var gameMap:GameMap
    var astar: Astar
    
    var wander: WanderBehaviour
    
    var firelight:Firelight
    
    override init(size: CGSize) {
        gameMap = GameMap(size: size)
        player = Player()
        zombie = Zombie()
        zombie2 = Zombie()

        firelight = Firelight()
        
        astar = Astar(map: gameMap.matrix)
        wander = WanderBehaviour()
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        view.showsPhysics = false
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        var c:SKSpriteNode
        for rows in gameMap.getMap() {
            for cell in rows {
                if (cell.isWalkable()) {
                    c = Floor()
                    c.position = cell.point
                } else {
                    c = Firelight()
                    c.position = cell.point
                }
                
                self.addChild(c)
            }
        }
        
        
        //PLAYER
        self.addChild(player)
        player.position = gameMap.getMap()[3][3].point
        player.gameScene = self
        player.zPosition = 1000

        //ENEMIES
        self.addChild(zombie)
        zombie.position = gameMap.getMap()[9][13].point
        zombie.gameScene = self
        zombie.zPosition = 1000

        self.addChild(zombie2)
        zombie2.position = gameMap.getMap()[6][10].point
        zombie2.gameScene = self
        zombie2.zPosition = 1000
        
        
        //FIRELIGHT
//        self.addChild(firelight)
//        firelight.position = gameMap.getMap()[0][0].point
//        firelight.gameScene = self
//        firelight.zPosition = 1000
        
        
        //CAMERA
        self.camera = cam
        cam.yScale = 0.7
        cam.xScale = 0.7
        
        createSceneContents()
    }
    
    
    func createSceneContents() {
        self.size = CGSize(width: self.size.width, height: self.size.height)
        self.backgroundColor = .white
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        print(pos)
        
        var auxCell:Cell = gameMap.pointToCell(point: pos)
        if(auxCell.point != CGPoint.zero) {
               move(destiny: pos)
        }

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //a estrella
        player.move() //para el player posta
        
        //wander
        if zombie.canWander {
            zombie.moveWander(playerCell: gameMap.pointToCell(point: zombie.position), wanderResult: wander.doWander(velocity: (zombie.physicsBody?.velocity)!))
        }
        zombie.isOtherPosition(otherCell: gameMap.pointToCell(point: zombie.position))
        
        //pursuit
        var steering:CGVector = PursuitBehaviour.pursuit(entity: gameMap.pointToCell(point: zombie2.position), target: gameMap.pointToCell(point: player.position), targetPlayer: player)
        
        steering = steering.truncate(value: 10)
        steering = steering / 1 // / mass
        zombie2.physicsBody?.velocity = (zombie2.physicsBody?.velocity)! + steering
        zombie2.physicsBody?.velocity = (zombie2.physicsBody?.velocity.truncate(value: 10))!
        
        cam.position = player.position
    }
    
    func move(destiny: CGPoint) {
        let path:[Cell] = astar.getPath(start: gameMap.pointToCell(point: player.position), goal: gameMap.pointToCell(point: destiny))
        for c in path {
            print(c.position)
        }
        player.walkPath(pathToWalk: path)
    }
}





















