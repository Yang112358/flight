//
//  GameViewController.swift
//  Flight Battle
//
//  Created by CaiYang on 4/21/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    var backingAudio = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        
        //let filePath = Bundle.main.path(forResource: "Background", ofType: "mp3")
        //let audioNSURL = NSURL(fileURLWithPath: filePath!)
        //do { backingAudio = try! AVAudioPlayer(contentsOfURL: audioNSURL)
        //catch { return print("cannot find the audio") }
        let audioURL = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Background", ofType: "mp3")!)
        backingAudio = try! AVAudioPlayer(contentsOf: audioURL as URL)
        
       
        backingAudio.prepareToPlay()
        backingAudio.numberOfLoops = -1
        backingAudio.volume = 0.2
        backingAudio.play()
            
            
            
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'GameScene.sks'
            
            let scene = transferScene (size: CGSize(width: 1536, height: 2048))
            
            // Set the scale mode to scale to fit the window
            
            scene.scaleMode = .aspectFill
            
            // Present the scene
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            
            view.showsNodeCount = true
        }
        
    }


    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
