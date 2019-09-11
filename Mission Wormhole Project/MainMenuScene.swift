//
//  MainMenuScene.swift
//  Mission Wormhole
//
//  Created by Eric Reese on 8/17/16.
//  Copyright © 2016 Eric Reese. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import AVFoundation

class MainMenuScene: SKScene{
    
    //Audio file variable
    var audioFileURL = Bundle.main.url(forResource: "ButtonClick", withExtension: "wav")!
    var player = AVAudioPlayer()
    
    
    //Initializes game nodes
    
    var easyNode: SKLabelNode?
    var mediumNode: SKLabelNode?
    var hardNode: SKLabelNode?
    static var currentScene: Int?
    
    override func didMove(to view: SKView) {
        
        //Add nodes to screen.
        easyNode = self.childNode(withName: "start") as? SKLabelNode
        mediumNode = self.childNode(withName: "instructions") as? SKLabelNode
        hardNode = self.childNode(withName: "center") as? SKLabelNode

    }
    
    //Change color of main menu nodes when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self){
            
            if easyNode!.contains(location){
                easyNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if mediumNode!.contains(location){
                mediumNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if hardNode!.contains(location){
                hardNode!.fontColor = UIColor.cyan
                playButtonSound()
            }
        }
    }
    
    //Keep cyan when on node, turn back to blue when off node
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
        
            if easyNode!.contains(location){
                easyNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if mediumNode!.contains(location){
                mediumNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if hardNode!.contains(location){
                hardNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else{
                easyNode!.fontColor = UIColor.blue
                mediumNode!.fontColor = UIColor.blue
                hardNode!.fontColor = UIColor.blue
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            
            if easyNode!.contains(location){
                
                //Present game scene with default game progress.
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.scaleMode = .aspectFill
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
                MainMenuScene.currentScene = 0
                
            }else if mediumNode!.contains(location){
                
                //Present game scene with 60 seconds of gameplay already completed.
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.scaleMode = .aspectFill
                
                nextScene!.currentTime = 60
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
                MainMenuScene.currentScene = 1
 
            }else if hardNode!.contains(location){
                
                //Present game scene with 120 seconds of gameplay already completed. 
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.scaleMode = .aspectFill
                
                nextScene!.currentTime = 120
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
                MainMenuScene.currentScene = 2
                
            }
        }
    }
    
    //Plays button sound
    func playButtonSound(){
        
        do{
            player = try AVAudioPlayer(contentsOf: audioFileURL)
            
            player.prepareToPlay()
            player.play()
            
        } catch _{
        }
    }
}
