//
//  GameOver.swift
//  SushiNeko
//
//  Created by Mikhael Gonzalez on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GameOver: CCNode {
    var scoreLabel: CCLabelTTF!
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    var restartButton: CCButton!
    
    func didLoadFromCCB() {
        restartButton.cascadeOpacityEnabled = true
        restartButton.runAction(CCActionFadeIn(duration: 0.3))
    }

}
