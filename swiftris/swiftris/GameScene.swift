//
//  GameScene.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import SpriteKit

let TickLengthLevelOne = TimeInterval(600)
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
    var lastTick:Date?
    
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
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSize(width: BlockSize * CGFloat(TotalColumns), height: BlockSize * CGFloat(TotalRows)))
        gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
        
        run(SKAction.repeatForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)))
    }
    
    func playSound(_ sound:String) {
        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    
    // MARK: - 'Tick' Logic
    // ----------------------

      
    override func update(_ currentTime: TimeInterval) {
        if lastTick == nil {
            return
        }
        
        // GB - Time passed should be returned as a positive millisecond value
        let timePassed = lastTick!.timeIntervalSinceNow * -MillisecondsInSecond
        if timePassed > tickLengthMillis {
            lastTick = Date()
            tick?()
        }
    }
    
    
    func startTicking() {
        lastTick = Date()
    }
    
    
    func stopTicking() {
        lastTick = nil
    }
    
    // ----------------------
    
    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
        let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPoint(x: x, y: y)
    }
    
    func addPreviewShapeToScene(_ shape:Shape, completion:@escaping () -> ()) {
        
        for (_, block) in shape.blocks.enumerated() {
   
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
            let moveAction = SKAction.move(to: pointForColumn(block.column, row: block.row), duration: TimeInterval(0.2))
            moveAction.timingMode = .easeOut
            let fadeInAction = SKAction.fadeAlpha(to: 0.7, duration: 0.4)
            fadeInAction.timingMode = .easeOut
            sprite.run(SKAction.group([moveAction, fadeInAction]))
        }
        
        run(SKAction.wait(forDuration: 0.4), completion: completion)
    }
    
    func movePreviewShape(_ shape:Shape, completion:@escaping () -> ()) {
        for (_, block) in shape.blocks.enumerated() {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.2)
            moveToAction.timingMode = .easeOut
            sprite.run(
                SKAction.group([moveToAction, SKAction.fadeAlpha(to: 1.0, duration: 0.2)]))
        }
        run(SKAction.wait(forDuration: 0.2), completion: completion)
    }
    
    func redrawShape(_ shape:Shape, completion:@escaping () -> ()) {
        for (_, block) in shape.blocks.enumerated() {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.move(to: moveTo, duration: 0.05)
            moveToAction.timingMode = .easeOut
            sprite.run(moveToAction)
        }
        run(SKAction.wait(forDuration: 0.05), completion: completion)
    }
    
    
    
    func animateCollapsingLines(_ linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:@escaping () -> ()) {
        var longestDuration: TimeInterval = 0
        // #2
        for (columnIdx, column) in fallenBlocks.enumerated() {
            for (blockIdx, block) in column.enumerated() {
                let newPosition = pointForColumn(block.column, row: block.row)
                let sprite = block.sprite!
                // #3
                let delay = (TimeInterval(columnIdx) * 0.05) + (TimeInterval(blockIdx) * 0.05)
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        moveAction]))
                longestDuration = max(longestDuration, duration + delay)
            }
        }
        
        for (_, row) in linesToRemove.enumerated() {
            for (_, block) in row.enumerated() {
                // #4
                let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = pointForColumn(block.column, row: block.row)
                point = CGPoint(x: point.x + (goLeft ? -randomRadius : randomRadius), y: point.y)
                
                let randomDuration = TimeInterval(arc4random_uniform(2)) + 0.5
                // #5
                var startAngle = CGFloat(Double.pi)
                var endAngle = startAngle * 2
                if goLeft {
                    endAngle = startAngle
                    startAngle = 0
                }
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                let archAction = SKAction.follow(archPath.cgPath, asOffset: false, orientToPath: true, duration: randomDuration)
                archAction.timingMode = .easeIn
                let sprite = block.sprite!
                // #6
                sprite.zPosition = 100
                sprite.run(
                    SKAction.sequence(
                        [SKAction.group([archAction, SKAction.fadeOut(withDuration: TimeInterval(randomDuration))]),
                            SKAction.removeFromParent()]))
            }
        }
        // #7
        run(SKAction.wait(forDuration: longestDuration), completion:completion)
    }
}
