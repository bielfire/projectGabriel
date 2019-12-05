//
//  GameScene.swift
//  projectGabriel
//
//  Created by Gabriel Jacinto on 05/12/19.
//  Copyright © 2019 Gabriel Jacinto. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var bear = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        buildBear()

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        moveBear(location: location)
    }
    
    func buildBear() {
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames: [SKTexture] = []
        
        let numImages = bearAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bearTextureName = "bear\(i)"
            walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        bearWalkingFrames = walkFrames
        let point = CGPoint(x: frame.midX, y: frame.midY)
        let firstFrameTexture = bearWalkingFrames[0]
        bear = SKSpriteNode(texture: firstFrameTexture)
        bear.position = point
        addChild(bear)
    }
    
    func animateBear() {
        
        bear.run(SKAction.repeatForever(SKAction.animate(with: bearWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey:"walkingInPlaceBear")
    }
    
    func moveBear(location: CGPoint) {
        // 1
        var multiplierForDirection: CGFloat
        
        // 2
        let bearSpeed = frame.size.width / 3.0
        
        // 3
        let moveDifference = CGPoint(x: location.x - bear.position.x, y: location.y - bear.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        
        // 4
        let moveDuration = distanceToMove / bearSpeed
        
        // 5
        if moveDifference.x < 0 {
            multiplierForDirection = 1.0
        }
        
        else {
            multiplierForDirection = -1.0
        }
        bear.xScale = abs(bear.xScale) * multiplierForDirection
        
        // 1
        if bear.action(forKey: "walkingInPlaceBear") == nil {
            // if legs are not moving, start them
            animateBear()
        }
        
        // 2
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        // 3
        let doneAction = SKAction.run({ [weak self] in
            self?.bearMoveEnded()
        })
        
        // 4
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        bear.run(moveActionWithDone, withKey:"bearMoving")
    }
    
    func bearMoveEnded() {
        bear.removeAllActions()
    }
}
