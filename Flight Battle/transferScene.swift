//
//  transferScene.swift
//  Flight Battle
//
//  Created by CaiYang on 5/5/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


//let FlightBattle = SKLabelNode(fontNamed: "The Bold Font")

class transferScene: SKScene{
    
    override func didMove(to view: SKView) {
        //UIColor *color = [UIColor whiteColor];
        //UIColor(white: 1, alpha: 1)
        view.backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "gaoda")
        background.size = CGSize(width: 700, height: 700*16/9)
        background.position = CGPoint(x:  self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let sceneToMoveTo = MainManuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
       
        
       
    }
    
   
    
    
    
}
