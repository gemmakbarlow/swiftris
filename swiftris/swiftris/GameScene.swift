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
let BlockSize:CGFloat = 20.0

let GameSceneBackgroundImageName = "background"
let GameBoardBackgroundImageName = "gameboard"

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)

    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()

    
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
        
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed: GameBoardBackgroundImageName)
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSizeMake(BlockSize * CGFloat(TotalColumns), BlockSize * CGFloat(TotalRows)))
        gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
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
    
    // ----------------------
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPointMake(x, y)
    }
    
    func addPreviewShapeToScene(shape:Shape, completion:() -> ()) {
        
        for (idx, block) in enumerate(shape.blocks) {
   
            // GB - Retrieve texture
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            
            
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = pointForColumn(block.column, row:block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            // Animation
            sprite.alpha = 0
            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)
            fadeInAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        
        runAction(SKAction.waitForDuration(0.4), completion: completion)
    }
    
    func movePreviewShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(
                SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion:nil)
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(moveToAction, completion: nil)
        }
        runAction(SKAction.waitForDuration(0.05), completion: completion)
    }
}
