//
//  Piece.swift
//  SushiNeko
//
//  Created by Mikhael Gonzalez on 7/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Piece: CCNode {
    weak var left: CCSprite!
    weak var right: CCSprite!
    
    var side: Side = .None {
        didSet {
            left.visible = false
            right.visible = false
            if side == .Right {
                right.visible = true
            } else if side == .Left {
                left.visible = true
            }
        }
    }
    
    func setObstacle(lastSide: Side) -> Side {
        if lastSide != .None {        // if last side was not none, set to None
            side = .None                // keeps unpassable state from occurring
        }else{
            var rand = CCRANDOM_0_1()
            if rand < 0.45 {
                side = .Left
            }else if rand < 0.90 {
                side = .Right
            } else {
                side = .None
            }
        }
        return side
    }

}
