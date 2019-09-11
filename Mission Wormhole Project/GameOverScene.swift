//
//  GameOverScene.swift
//  Mission Wormhole
//
//  Created by Eric Reese on 8/16/16.
//  Copyright © 2016 Eric Reese. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class GameOverScene: SKScene{
    
    //Audio file variable
    var audioFileURL = Bundle.main.url(forResource: "ButtonClick", withExtension: "wav")!
    var player = AVAudioPlayer()
    
    let playAgainNode: SKLabelNode = SKLabelNode(text: "Play Again?")
    let mainMenuNode: SKLabelNode = SKLabelNode(text: "Main Menu")
    
    var score: Int = GameScene.score
    var highScore: Int = GameScene.highScore
    
    var scoreNode = SKLabelNode(text: "Score: ")
    
    //Creates and adds all necessary nodes when the game ends.
    override func didMove(to view: SKView) {
        
        //Adds score node.
        scoreNode.text = "Score: \(score)"
        scoreNode.position.y = self.size.height - 100
        scoreNode.position.x = self.size.width/2
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.fontColor = UIColor.white
        scoreNode.fontSize = 50
        
        let gameOverNode: SKLabelNode = SKLabelNode(text: "Game Over")
        
        //Adds game over node.
        gameOverNode.fontColor = UIColor.red
        gameOverNode.position.x = self.size.width/2
        gameOverNode.position.y = self.size.height/2
        gameOverNode.physicsBody?.affectedByGravity = false
        gameOverNode.fontSize = 100
        
        //Adds play again node.
        playAgainNode.position.x = self.size.width/2
        playAgainNode.position.y = self.size.height/2 - 300
        playAgainNode.fontColor = UIColor.blue
        playAgainNode.fontSize = 60
    
        //Adds main menu node.
        mainMenuNode.position.x = self.size.width/2
        mainMenuNode.position.y = playAgainNode.position.y - 100
        mainMenuNode.fontSize = 60
        mainMenuNode.fontColor = UIColor.blue
        
        let highScoreNode: SKLabelNode = SKLabelNode(text: "HighScore: ")
        
        //Adds high score node.
        highScoreNode.text = "HighScore: \(highScore)"
        highScoreNode.position.y = scoreNode.position.y - 75
        highScoreNode.position.x = self.size.width/2
        highScoreNode.physicsBody?.affectedByGravity = false
        highScoreNode.fontColor = UIColor.white
        highScoreNode.fontSize = 50
        
        self.addChild(scoreNode)
        self.addChild(highScoreNode)
        self.addChild(mainMenuNode)
        self.addChild(playAgainNode)
        self.addChild(gameOverNode)
        
        self.backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    //Change color of main menu nodes when touched
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self){
            
            if playAgainNode.contains(location){
                
                playAgainNode.fontColor = UIColor.cyan
                playButtonSound()
                
            }else if mainMenuNode.contains(location){
                
                mainMenuNode.fontColor = UIColor.cyan
                playButtonSound()
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            
            if playAgainNode.contains(location){
                playAgainNode.fontColor = UIColor.cyan
                playButtonSound()
            }else if mainMenuNode.contains(location){
                mainMenuNode.fontColor = UIColor.cyan
                playButtonSound()
            }else{
                playAgainNode.fontColor = UIColor.blue
                mainMenuNode.fontColor = UIColor.blue
            }
        }
    }
    
    
    //Checks if touch is in menu or play again.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            
            if playAgainNode.contains(location){
                
                //Present easy game scene.
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
            
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene!.scaleMode = .aspectFill
                
                if (MainMenuScene.currentScene == 1){
                    nextScene?.currentTime = 60
                } else if (MainMenuScene.currentScene == 2){
                    nextScene?.currentTime = 120
                }
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
                GameScene.score = 0
                
                
            } else if mainMenuNode.contains(location){
                
                //Present main menu scene
                
                playButtonSound()
                
                let transition = SKTransition.fade(withDuration: TimeInterval(1.0))
                
                let nextScene = MainMenuScene(fileNamed: "MainScene")
                nextScene?.scaleMode = .aspectFill
                
                scene!.view!.presentScene(nextScene!, transition: transition)
                
                GameScene.score = 0
                
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
