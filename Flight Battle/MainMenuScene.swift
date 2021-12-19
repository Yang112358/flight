//
//  MainMenuScene.swift
//  Flight Battle
//
//  Created by CaiYang on 4/28/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

let FlightBattle = SKLabelNode(fontNamed: "The Bold Font")

class MainManuScene: SKScene{
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "Background 1")
        background.size = self.size
        background.position = CGPoint(x:  self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        //self.addChild(background)
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Yang"
        gameName1.fontSize = 160
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.text = "Cai"
        gameName2.fontSize = 160
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        
        //let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        FlightBattle.text = "Flight Battle"
        FlightBattle.fontSize = 100
        FlightBattle.fontColor = SKColor.white
        FlightBattle.zPosition = 1
        FlightBattle.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        
        FlightBattle.name = "Flight Battle"
        
        self.addChild(FlightBattle)
        
        let FlightBattle2 = SKLabelNode(fontNamed: "The Bold Font")
        FlightBattle2.text = "Game 2"
        FlightBattle2.fontSize = 100
        FlightBattle2.fontColor = SKColor.white
        FlightBattle2.zPosition = 1
        FlightBattle2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        
        FlightBattle2.name = "Game 2"
        
        self.addChild(FlightBattle2)
        
        
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
            
            if nodeITouch.name == "Flight Battle"{
                let sceneToMoveTo = GameStart(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
        }
    }
    
    
    
    
}
