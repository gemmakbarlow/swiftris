//
//  GameViewController.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

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
        swiftris.beginGame()
        
        currentView.presentScene(scene)
        
        scene.addPreviewShapeToScene(swiftris.nextShape!) {
            self.swiftris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.swiftris.nextShape!) {
                let nextShapes = self.swiftris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!) {}
            }
        }
        
    }
    
    func didTick() {
        swiftris.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(swiftris.fallingShape!, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
