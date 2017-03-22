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

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var scene: GameScene!
    var swiftris:SwiftrisGame!
    var panPointReference:CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentView = view as! SKView
        currentView.isMultipleTouchEnabled = false
        
        scene = GameScene(size: currentView.bounds.size)
        scene.scaleMode = .aspectFill

        scene.tick = didTick
        
        swiftris = SwiftrisGame()
        swiftris.delegate = self
        swiftris.beginGame()
        
       
        
        currentView.presentScene(scene)
        
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - SwiftrisGameDelegate 
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            
            self.scene.movePreviewShape(fallingShape) {
                self.view.isUserInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    
    func gameDidBegin(_ swiftris: SwiftrisGame) {
        
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(_ swiftris: SwiftrisGame) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        scene.playSound("gameover.mp3")
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: Array<Array<Block>>()) {
            swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(_ swiftris: SwiftrisGame) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound("levelup.mp3")
    }
    
    func gameShapeDidDrop(_ swiftris: SwiftrisGame) {
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        
        scene.playSound("drop.mp3")
    }
    
    func gameShapeDidLand(_ swiftris: SwiftrisGame) {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        // #1
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #2
                self.gameShapeDidLand(swiftris)
            }
            scene.playSound("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(_ swiftris: SwiftrisGame) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
    
    // MARK: - Actions

    @IBAction func didTap(_ sender: AnyObject) {
        swiftris.rotateShape()
    }
    
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {

        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {

            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {

                if sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    
    @IBAction func didSwipeDown(_ sender: AnyObject) {
        swiftris.dropShape()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = gestureRecognizer as? UISwipeGestureRecognizer {
            if let _ = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let _ = gestureRecognizer as? UIPanGestureRecognizer {
            if let _ = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
}
