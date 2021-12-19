//
//  GameOverScene.swift
//  Flight Battle
//
//  Created by CaiYang on 4/25/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import Foundation
import SpriteKit

        let restartLabel = SKLabelNode(fontNamed: "The Bold Font")

        let returnToMain = SKLabelNode(fontNamed: "The Bold Font")

class GameOverScene: SKScene{
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Background 1")
        background.size = self.size
        background.position = CGPoint(x:  self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 170
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore) "
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        self.addChild(highScoreLabel)
        
        
        //let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        
        self.addChild(restartLabel)
        
        returnToMain.text = "Return To Main Menu"
        returnToMain.fontSize = 60
        returnToMain.fontColor = SKColor.white
        returnToMain.zPosition = 1
        returnToMain.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        
        self.addChild(returnToMain)
        
        
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
            if returnToMain.contains(pointOfTouch){
                let sceneToMoveToMain = MainManuScene(size: self.size)
                sceneToMoveToMain.scaleMode = self.scaleMode
                let myTransitionMain = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveToMain, transition: myTransitionMain)
            }
            
        }
    }
    
    
}
