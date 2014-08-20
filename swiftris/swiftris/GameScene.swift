//
//  GameScene.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import SpriteKit

let TickLengthLevelOne = NSTimeInterval(600)
let MillisecondsInSecond = 1000.0
let GameSceneBackgroundImageName = "background"

class GameScene: SKScene {

    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    // MARK: - Initialization
    // ----------------------
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported!") // GB - This is how you handle required methods, (or just leave them empty?)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: GameSceneBackgroundImageName)
        background.position = CGPoint(x: 0.0, y: 0.0)
        background.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        
        addChild(background)
    }
    
    
    
    // MARK: - 'Tick' Logic
    // ----------------------

      
    override func update(currentTime: CFTimeInterval) {
        if lastTick == nil {
            return
        }
        
        // GB - Time passed should be returned as a positive millisecond value
        var timePassed = lastTick!.timeIntervalSinceNow * -MillisecondsInSecond
        if timePassed > tickLengthMillis {
            lastTick = NSDate.date()
            tick?()
        }
    }
    
    
    func startTicking() {
        lastTick = NSDate.date()
    }
    
    
    func stopTicking() {
        lastTick = nil
    }
}
