//
//  MainMenuScene.swift
//  Flight Battle
//
//  Created by CaiYang on 4/25/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import Foundation
import SpriteKit

let startLabel = SKLabelNode(fontNamed: "The Bold Font")

class GameStart: SKScene{
    override func didMove(to view: SKView) {
     
        let background = SKSpriteNode(imageNamed: "Background 1")
        background.size = self.size
        background.position = CGPoint(x:  self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Flight"
        gameName1.fontSize = 170
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.text = "Battle"
        gameName2.fontSize = 170
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        
        //let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        startLabel.text = "Start"
        startLabel.fontSize = 160
        startLabel.fontColor = SKColor.white
        startLabel.zPosition = 1
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        
        startLabel.name = "startButtom"
        
        self.addChild(startLabel)
        
    }
    
   // override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   //     for touch: AnyObject in touches{
   //         let pointOfTouch = touch.location(in: self)
   //         if startLabel.contains(pointOfTouch){
   //             let sceneToMoveTo = GameScene(size: self.size)
   //             sceneToMoveTo.scaleMode = self.scaleMode
   //             let myTransition = SKTransition.fade(withDuration: 0.5)
   //             self.view!.presentScene(sceneToMoveTo, transition: myTransition)
   //           }
   //     }
   // }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITouch = atPoint(pointOfTouch)
            
            if nodeITouch.name == "startButtom"{
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
        }
    }
    
    
    
    
}
