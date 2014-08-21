//
//  GameViewController.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisGameDelegate, UIGestureRecognizerDelegate {

    var scene: GameScene!
    var swiftris:SwiftrisGame!
    var panPointReference:CGPoint?
    
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
        
    }
    
    func didTick() {
        swiftris.letShapeFall()
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
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
    }
    
    func gameShapeDidLand(swiftris: SwiftrisGame) {
        scene.stopTicking()
        nextShape()
    }
    
    func gameShapeDidMove(swiftris: SwiftrisGame) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
    
    // MARK: - Actions

    @IBAction func didTap(sender: AnyObject) {
        swiftris.rotateShape()
    }
    
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {

        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {

            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {

                if sender.velocityInView(self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    
    @IBAction func didSwipeDown(sender: AnyObject) {
        swiftris.dropShape()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
}
