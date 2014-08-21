//
//  GameViewController.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisGameDelegate {

    var scene: GameScene!
    var swiftris:SwiftrisGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentView = view as SKView
        currentView.multipleTouchEnabled = false
        
        scene = GameScene(size: currentView.bounds.size)
        scene.scaleMode = .AspectFill

        scene.tick = didTick
        
        swiftris = SwiftrisGame()
        swiftris.delegate = self
        swiftris.beginGame()
        
       
        
        currentView.presentScene(scene)
        
//        scene.addPreviewShapeToScene(swiftris.nextShape!) {
//            self.swiftris.nextShape?.moveTo(StartingColumn, row: StartingRow)
//            self.scene.movePreviewShape(self.swiftris.nextShape!) {
//                let nextShapes = self.swiftris.newShape()
//                self.scene.startTicking()
//                self.scene.addPreviewShapeToScene(nextShapes.nextShape!) {}
//            }
//        }
        
    }
    
    func didTick() {
        swiftris.letShapeFall()
//        swiftris.fallingShape?.lowerShapeByOneRow()
//        scene.redrawShape(swiftris.fallingShape!, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - SwiftrisGameDelegate 
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            
            self.scene.movePreviewShape(fallingShape) {
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    
    func gameDidBegin(swiftris: SwiftrisGame) {
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: SwiftrisGame) {
        view.userInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: SwiftrisGame) {
        
    }
    
    func gameShapeDidDrop(swiftris: SwiftrisGame) {
        
    }
    
    func gameShapeDidLand(swiftris: SwiftrisGame) {
        scene.stopTicking()
        nextShape()
    }
    
    func gameShapeDidMove(swiftris: SwiftrisGame) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
}
