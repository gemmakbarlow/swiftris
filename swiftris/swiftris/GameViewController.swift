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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentView = view as SKView
        currentView.multipleTouchEnabled = false
        
        var scene: GameScene!
        scene = GameScene(size: currentView.bounds.size)
        scene.scaleMode = .AspectFill
        
        currentView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
