//
//  MainScene.swift
//  Mission Wormhole
//
//  Created by Eric Reese on 5/31/17.
//  Copyright © 2017 Eric Reese. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class MainScene: SKScene{
    
    //Audio file variable
    var audioFileURL = Bundle.main.url(forResource: "ButtonClick", withExtension: "wav")!
    var player = AVAudioPlayer()
    
    var playGameNode: SKLabelNode?
    var instructionsNode: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        //Add nodes to screen.
        playGameNode = self.childNode(withName: "playGame") as? SKLabelNode
        instructionsNode = self.childNode(withName: "instructions") as? SKLabelNode
    }
    
    //Change color of main menu nodes when touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self){
            
            if playGameNode!.contains(location){
                playGameNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if instructionsNode!.contains(location){
                instructionsNode!.fontColor = UIColor.cyan
                playButtonSound()
            }
        }
    }
    
    //Keep cyan when on node, turn back to blue when off node
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            
            if playGameNode!.contains(location){
                playGameNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else if instructionsNode!.contains(location){
                instructionsNode!.fontColor = UIColor.cyan
                playButtonSound()
            }else{
                playGameNode!.fontColor = UIColor.blue
                instructionsNode!.fontColor = UIColor.blue
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            
            if playGameNode!.contains(location){
                
                //Presents main menu scene
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = GameScene(fileNamed: "MainMenuScene")
                nextScene!.scaleMode = .aspectFill
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
            }else if instructionsNode!.contains(location){
                
                //Presents instructions
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = GameScene(fileNamed: "Instructions")
                nextScene!.scaleMode = .aspectFill
                
                scene!.view!.presentScene(nextScene!, transition: transition)
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
