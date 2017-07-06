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

    let maxLife:Int = 10
    
    var player:Player
    var zombie:[Zombie]
    var gameMap:GameMap
    
    var astar: Astar
    var wander: WanderBehaviour
    var pursuit: PursuitBehaviour
    
    var sword:Sword
    var hud:HUD!
    
    override init(size: CGSize) {
        gameMap = GameMap(size: size)
        player = Player(maxLife: maxLife)
        zombie = [Zombie]()
        zombie.append(Zombie())
        zombie.append(Zombie())

        sword = Sword()
        
        astar = Astar(map: gameMap.matrix)
        wander = WanderBehaviour()
        pursuit = PursuitBehaviour()
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
        player.setCell(c: gameMap.getMap()[3][3])
        player.gameScene = self
        player.zPosition = 2000

        //ENEMIES
        self.addChild(zombie[0])
        zombie[0].setCell(c: gameMap.getMap()[9][13])
        zombie[0].gameScene = self
        zombie[0].zPosition = 1000

        self.addChild(zombie[1])
        zombie[1].setCell(c: gameMap.getMap()[9][13])
        zombie[1].gameScene = self
        zombie[1].zPosition = 1000
        
        //SWORD
        self.addChild(sword)
        sword.zPosition = 1000
        sword.position = gameMap.getMap()[5][5].point
        gameMap.getMap()[5][5].setItem(item: sword)
        
        //CAMERA
        self.camera = cam
        cam.yScale = 0.7
        cam.xScale = 0.7
        
        hud = HUD(cam: cam, maxLife: maxLife, sksc: self)

        createSceneContents()
    }
    
    func createSceneContents() {
        self.size = CGSize(width: self.size.width, height: self.size.height)
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        let auxCell:Cell = gameMap.pointToCell(point: pos)
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
        var path:[Cell]
        
        //ataca player
        player.attack(map: gameMap.getMap(), enemies: zombie)
        
        //se mueve player
        player.move()
        
        //atacan enemies
        for i in 0 ..< zombie.count {
            zombie[i].attack(player: player)
        }
        
        //se mueven enemies
        for i in 0 ..< zombie.count {
            zombie[i].checkMode(player: player.myCell)
            
            if zombie[i].mode == EnemyConstants.WANDER_MODE {
                print("zombie\(i) esta en WANDER")
                path = WanderBehaviour.doWander(map: gameMap.getMap(), enemy: zombie[i].myCell, astar: astar)
                zombie[i].walkPath(pathToWalk: path)
                
            } else if zombie[i].mode == EnemyConstants.PURSIUT_MODE {
                print("zombie\(i) esta en PURSUIT")
                path = PursuitBehaviour.pursuit(start: gameMap.pointToCell(point: zombie[i].position), goal: gameMap.pointToCell(point: player.position), astar: astar)
                zombie[i].walkPath(pathToWalk: path)
            }
            
            zombie[i].move()
        }

        //CAMERA
        cam.position = player.position

        //HUD: head-up display
        hud.update(positionCam: cam.position, playerLife: player.life)
    }
    
    func move(destiny: CGPoint) {
        let path:[Cell] = astar.getPath(start: player.nextCell, goal: gameMap.pointToCell(point: destiny))
//      imprime el camino a estrella del player
//      for c in path { print(c.position)  }
        player.walkPath(pathToWalk: path)
    }
}





















