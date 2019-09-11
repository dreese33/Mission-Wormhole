//
//  GameScene.swift
//  Mission Wormhole
//
//  Created by Eric Reese on 8/13/16.
//  Copyright © 2016 Eric Reese. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene{
    
    //Score text
    var scoreText: String?
    var highScoreText: String?
    
    //Labels for distance and distanceHigh
    var distance: UILabel?
    var distanceHigh: UILabel?
    
    //Pause timer variable
    var pauseTimers: Bool = false
    
    //Distance traveled variable
    var distanceTraveled: CGFloat = 0.0
    var scaleFactor: CGFloat = 1.0
    
    //Progress Value
    var progressValue: CGFloat = 1.0
    var progressAddition: CGFloat = 0.0
    var progressSubtraction: CGFloat = 0.0
    var progressGemValue: CGFloat = 0.0
    
    //Rectangle for shapes
    var shapeRect: CGRect?
    
    //Spaceship movement boolean
    static var spaceShipEngineActive: Bool = false
    
    //Creates global variables for mainSubview and fuelQuantity
    var mainSubview: UIView?
    var fuelQuantity: Shapes?
    
    //Screen size
    static let screenSizeX = UIScreen.main.bounds.width
    static let screenSizeY = UIScreen.main.bounds.height
    
    //MainViewDimensions
    static let mainViewWidth: CGFloat = GameScene.screenSizeX
    static let mainViewHeight: CGFloat = GameScene.screenSizeY/6
    
    //FuelQuantity Dimensions
    static let fuelQuantityWidth: CGFloat = (5/6)*GameScene.mainViewWidth+4
    static let fuelQuantityHeight: CGFloat = (1/4)*GameScene.mainViewHeight+2
    
    //Current number of black holes
    var currentNumberOfHoles: Int = 0
    
    //Audio file variables
    var audioButtonFileURL = Bundle.main.url(forResource: "ButtonClick", withExtension: "wav")!
    var audioFlameFileURL = Bundle.main.url(forResource: "SpaceShipFlame", withExtension: "mp3")!
    var player = AVAudioPlayer()
    var player1 = AVAudioPlayer()
    var player2 = AVAudioPlayer()
    var audioBingFileURL = Bundle.main.url(forResource: "Bing", withExtension: "wav")!
    
    //Database interaction.
    var storedValues: UserDefaults?
    
    //Timer
    var timer: Timer?
    var didStart: Bool?
    
    //Timer for progress bar
    var progressBarTimer: Timer?
    
    var doNotProgressGameFurther: Bool = false
    
    //Current random number of black holes.
    var currentRandom: Int?
    
    //Current random number of black holes.
    var currentRandomGems: Int?
    
    var time: CGFloat = 3.0
    
    var currentTime = 0
    
    //Final number of black holes allowed to be present.
    let finalMaxOfBlackHoles: Int = 11
    let finalMinOfBlackHoles: Int = 5
    
    //Starting number of black holes allowed to be present.
    var currentMaxOfBlackHoles: Int = 6
    var currentMinOfBlackHoles: Int = 2
    
    //Starting Black Hole Time Range.
    var currentMinTimeBlackHolesLast: Int = 3
    var currentMaxTimeBlackHolesLast: Int = 7
    
    //Ending Black Hole Time Range.
    let minTimeBlackHolesLast: Int = 1
    let maxTimeBlackHolesLast: Int = 11
    
    //Starting black hole radius range.
    var currentRadiusMin: CGFloat = 5.0
    var currentRadiusMax: CGFloat = 11.0
    
    //Ending black hole radius range.
    var endingRadiusMin: CGFloat = 25.0
    var endingRadiusMax: CGFloat = 51.0
    
    static var score: Int = 0
    static var highScore: Int = 0
    //static var numberOfGems: Int = 0
    
    //Angle of spaceship
    var angleOfAttack: CGFloat = 0.0
    
    var wormhole: [SKShapeNode] = [
                                   SKShapeNode(circleOfRadius: 750.0),
                                   SKShapeNode(circleOfRadius: 700.0),
                                   SKShapeNode(circleOfRadius: 650.0),
                                   SKShapeNode(circleOfRadius: 600.0),
                                   SKShapeNode(circleOfRadius: 550.0),
                                   SKShapeNode(circleOfRadius: 500.0),
                                   SKShapeNode(circleOfRadius: 450.0),
                                   SKShapeNode(circleOfRadius: 400.0),
                                   SKShapeNode(circleOfRadius: 350.0),
                                   SKShapeNode(circleOfRadius: 300.0),
                                   SKShapeNode(circleOfRadius: 250.0),
                                   SKShapeNode(circleOfRadius: 200.0),
                                   ]
    
    var spaceShip: SKSpriteNode?
    var blackHoles: [BlackHole] = []
    var gems: [Gem] = []
    
    var lastTouch: CGPoint? = nil
   
    //Initialize all sprites, audio nodes, etc. 
    override func didMove(to view: SKView) {
        
        //Creates fuel label
        let fuelLabelHeight = GameScene.fuelQuantityHeight
        let fuelLabelWidth = GameScene.mainViewWidth-GameScene.fuelQuantityWidth-4
        let fuelLabel: UIImage = UIImage(named: "FuelLabel.png")!
        let fuelLabelView = UIImageView(image: fuelLabel)
        fuelLabelView.bounds = CGRect(x: 0, y: 0, width: fuelLabelWidth, height: fuelLabelHeight)
        fuelLabelView.center = CGPoint(x: (fuelLabelWidth/2), y: GameScene.mainViewHeight-(fuelLabelHeight/2))
        
        //Main subview to be implemented
        mainSubview = UIView(frame: CGRect(x: 0, y: GameScene.screenSizeY-GameScene.mainViewHeight, width: GameScene.mainViewWidth, height: GameScene.mainViewHeight))
        mainSubview?.backgroundColor = UIColor.black
        
        //TEST --- Draw the shape for the fuel tank
        shapeRect = CGRect(x: GameScene.mainViewWidth-GameScene.fuelQuantityWidth, y: GameScene.mainViewHeight-GameScene.fuelQuantityHeight, width: GameScene.fuelQuantityWidth, height: GameScene.fuelQuantityHeight)
        fuelQuantity = Shapes(frame: shapeRect!)
        
        //Draws horizontal line
        let h1Y = GameScene.mainViewHeight-GameScene.fuelQuantityHeight-8
        let horizontalLine = CGRect(x: 0, y: h1Y, width: GameScene.mainViewWidth, height: 3)
        let horizontalLineView = UIView(frame: horizontalLine)
        horizontalLineView.backgroundColor = UIColor.white
        mainSubview?.addSubview(horizontalLineView)
        
        //Draws vertical line 
        let verticalLine = CGRect(x: (GameScene.mainViewWidth/2)-3, y: 0, width: 3, height: GameScene.mainViewHeight-GameScene.fuelQuantityHeight-8)
        let verticalLineView = UIView(frame: verticalLine)
        verticalLineView.backgroundColor = UIColor.white
        mainSubview?.addSubview(verticalLineView)
        
        //Creates distance label
        let distanceLabelHeight = (1/8)*GameScene.mainViewHeight
        let distanceLabelWidth = (3/8)*(GameScene.mainViewWidth)-3
        let centerX = GameScene.mainViewWidth/4
        let centerY = (distanceLabelHeight/2) + ((2/25)*GameScene.mainViewHeight)
        let distanceLabel: UIImage = UIImage(named: "DistanceTraveled.png")!
        let distanceLabelView = UIImageView(image: distanceLabel)
        distanceLabelView.bounds = CGRect(x: centerX, y: centerY, width: distanceLabelWidth, height: distanceLabelHeight)
        distanceLabelView.center = CGPoint(x: centerX, y: centerY)
        mainSubview?.addSubview(distanceLabelView)
        
        //Creates farthest distance label
        let farthestCenterX = GameScene.mainViewWidth*(3/4)
        let farthestLabel: UIImage = UIImage(named: "FarthestTraveled.png")!
        let farthestLabelView = UIImageView(image: farthestLabel)
        farthestLabelView.bounds = CGRect(x: farthestCenterX, y: centerY, width: distanceLabelWidth, height: distanceLabelHeight)
        farthestLabelView.center = CGPoint(x: farthestCenterX, y: centerY)
        mainSubview?.addSubview(farthestLabelView)
        
        
        //Draws vertical line 2
        let verticalLine2 = CGRect(x: 0, y: 0, width: 3, height: GameScene.mainViewHeight-GameScene.fuelQuantityHeight-8)
        let verticalLineView2 = UIView(frame: verticalLine2)
        verticalLineView2.backgroundColor = UIColor.white
        mainSubview?.addSubview(verticalLineView2)
        
        //Draws vertical line 3
        let verticalLine3 = CGRect(x: GameScene.mainViewWidth-3, y: 0, width: 3, height: GameScene.mainViewHeight-GameScene.fuelQuantityHeight-8)
        let verticalLineView3 = UIView(frame: verticalLine3)
        verticalLineView3.backgroundColor = UIColor.white
        mainSubview?.addSubview(verticalLineView3)
        
        //Draws horizontal line 2
        let horizontalLine2 = CGRect(x: 0, y: 0, width: GameScene.mainViewWidth, height: 3)
        let horizontalLineView2 = UIView(frame: horizontalLine2)
        horizontalLineView2.backgroundColor = UIColor.white
        mainSubview?.addSubview(horizontalLineView2)
        
        //Adds fuelQuantity to mainSubview
        mainSubview?.addSubview(fuelLabelView)
        mainSubview?.addSubview(fuelQuantity!)
        self.view?.addSubview(mainSubview!)
        
        
        //Activates score database.
        storedValues = UserDefaults.standard
        
        //Adds wormhole to scene
        for circle in wormhole{
            circle.lineWidth = 50.0
            self.addChild(circle)
        }
        
        //Draws horizontal line 3
        let horizontalLine3 = CGRect(x: 0, y: 2*centerY, width: GameScene.mainViewWidth, height: 3)
        let horizontalLineView3 = UIView(frame: horizontalLine3)
        horizontalLineView3.backgroundColor = UIColor.white
        mainSubview?.addSubview(horizontalLineView3)
        
        //Creates and adds distance label to mainSubview
        let textColorDistance = UIColor(red: 12, green: 255, blue: 0, alpha: 1.0)
        let distanceCenterX = GameScene.mainViewWidth/4
        let distanceCenterY = ((2*centerY)+h1Y)/2
        let distanceWidth = GameScene.mainViewWidth/3
        let distanceHeight = sqrt(pow(2*centerY,2) + pow(h1Y,2))
        self.distance = UILabel(frame: CGRect(x: 0, y: 0, width: distanceWidth, height: distanceHeight))
        self.distance?.center = CGPoint(x: distanceCenterX, y: distanceCenterY)
        self.distance?.textColor = textColorDistance
        self.distance?.adjustsFontSizeToFitWidth = true
        self.distance?.textAlignment = NSTextAlignment.center
        scoreText = "\(GameScene.score) km"
        self.distance?.text = scoreText
        mainSubview?.addSubview(distance!)
        
        //Read from high score database.
        GameScene.highScore = storedValues!.integer(forKey: "HighScore")
        if GameScene.highScore == 0{
            storedValues!.set(GameScene.highScore, forKey: "HighScore")
            storedValues!.synchronize()
        }
        
        //Creates and adds distanceHigh label to mainSubview
        let distanceHighCenterX = ((3*GameScene.mainViewWidth)-6)/4
        self.distanceHigh = UILabel(frame: CGRect(x: 0, y: 0, width: distanceWidth, height: distanceHeight))
        self.distanceHigh?.center = CGPoint(x: distanceHighCenterX, y: distanceCenterY)
        self.distanceHigh?.textColor = textColorDistance
        self.distanceHigh?.adjustsFontSizeToFitWidth = true
        self.distanceHigh?.textAlignment = NSTextAlignment.center
        highScoreText = "\(GameScene.highScore) km"
        self.distanceHigh?.text = highScoreText
        mainSubview?.addSubview(distanceHigh!)
        
        //Adds spaceship to scene
        spaceShip = self.childNode(withName: "spaceShip") as? SKSpriteNode
        spaceShip!.physicsBody!.usesPreciseCollisionDetection = true
        
        //Initial random number.
        self.currentRandom = Int(arc4random_uniform(UInt32(currentMaxOfBlackHoles-currentMinOfBlackHoles))) + currentMinOfBlackHoles
        
        //Initial random number of gems.
        self.currentRandomGems = Int(arc4random_uniform(3)) + 2
    }
    
    //Determines whether or not game should continue or end
    private func didDie(_ currentPosition: CGPoint) -> Bool{
        
        var die = false
        switch(die){
        case currentPosition.x > -self.size.width/2: //Did it cross the left?
            die = true
        case currentPosition.x < self.size.width/2: //Did it cross the right?
            die = true
        case currentPosition.y > -self.size.height/2: //Did it cross the bottom?
            die = true
        case currentPosition.y < self.size.height/2: //Did it cross to top?
            die = true
        default:
            die = false
        }

        //Determines whether black hole intersects ship.
        for hole in blackHoles{
            if hole.intersects(spaceShip!){
                die = true
                break
            }
        }
        
        var index: Int = 0
        
        for gem in gems{
            if gem.intersects(spaceShip!){
                
                progressValue += progressGemValue
                //Delete this code soon
                playBingSound()
            
                gem.removeFromParent()
                gems.remove(at: index)
                index -= 1
                break
            }
            index += 1
        }
        
        return die
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Begin progress bar timer
        //Begin game timer.
        if self.didStart == nil{
            
            self.progressBarTimer = Timer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.updateProgressBar), userInfo: nil, repeats: true)
            self.timer = Timer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(GameScene.updateAll), userInfo: nil, repeats: true)
            RunLoop.current.add(self.progressBarTimer!, forMode: .common)
            RunLoop.current.add(self.timer!, forMode: .common)
            self.didStart = true
        }
        
        //Add flame effect
        if (progressValue >= 0.1){
            spaceShip?.texture = SKTexture(imageNamed: "Spaceship.png")
            playFlameSound()
        }
        
        handleTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        handleTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        spaceShip?.texture = SKTexture(imageNamed: "SpaceShipNoFlame")
        stopFlameSound()
        
        handleTouches(touches)
        
    }
    
    private func handleTouches(_ touches: Set<UITouch>){
        for touch in touches{
            let touchLocation = touch.location(in: self)
            lastTouch = touchLocation
        }
    }
    
    override func didSimulatePhysics() {
        
        if let _ = spaceShip{
            updateSpaceShip()
            
            if !doNotProgressGameFurther{
                updateGameProgress()
            }
        }
    }
    
    
    //Moves to last location touched
    //Points nose of spaceship to last location touched
    func updateSpaceShip(){
        
        //Keep this code
        if GameScene.score > GameScene.highScore{
            
            GameScene.highScore = GameScene.score
            
            //Write to database.
            storedValues!.set(GameScene.highScore, forKey: "HighScore")
            storedValues!.synchronize()
        }
        
        distance?.text = "\(GameScene.score) km"
        distanceHigh?.text = "\(GameScene.highScore) km"

        let currentLocation = spaceShip!.position
        
        if didDie(currentLocation){
            endGame()
        } else{
            
            if let touch = lastTouch{
                
                if (GameScene.spaceShipEngineActive){
                    self.angleOfAttack = atan2(currentLocation.y - touch.y, currentLocation.x - touch.x)
                    let rotateAction = SKAction.rotate(toAngle: angleOfAttack + CGFloat.pi / 2, duration: 0.1)
                
                    spaceShip!.run(rotateAction)
                
                    let moveAction = SKAction.move(to: touch, duration: TimeInterval(time))
                    spaceShip!.run(moveAction)
                
                }
                //Generates correct number of black holes.
                let bool: Bool = true
                
                switch(bool){
                case currentRandom! > currentNumberOfHoles:
                    var numberOff = currentRandom! - currentNumberOfHoles
                    repeat {
                        generateBlackHole()
                        currentNumberOfHoles += 1
                        numberOff -= 1
                    }while (numberOff > 0)
                case currentRandom! < currentNumberOfHoles:
                    self.currentRandom = currentNumberOfHoles
                default:
                    break
                }
                
                //Generates correct number of gems.
                let bool2 = true
                
                switch(bool2){
                case currentRandomGems! > gems.count:
                    var numberOff = currentRandomGems! - gems.count
                    repeat {
                        generateGem()
                        numberOff -= 1
                    }while (numberOff > 0)
                case currentRandomGems! < gems.count:
                    self.currentRandomGems = gems.count
                default:
                    break
                }
                
            }
        }
    }
    
    //Code to execute when game ends
    func endGame(){
        
        //Number of gems needed to finish level.
        //Highscore database interaction.
        //Sets continue and main menu labels visible
        
        //Fixes bug
        //Delay code for the game to end after spaceship explosion
        self.progressValue = 0.0
        
        self.pauseTimers = true
        
        stopFlameSound()
        
        mainSubview!.isHidden = true
        
        timer?.invalidate()
        progressBarTimer?.invalidate()
        
        //play explosion sound
        
        let newScene: SKScene = GameOverScene(size: self.size)
        
        self.removeAllActions()
        self.removeAllChildren()
        self.scene!.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: TimeInterval(1.0)))
        
    }
    
    //Code to make game harder as time goes on
    func updateGameProgress(){
        
        //Updates current values until max values are reached.
        
        
        //MAX:
        //currentRadiusMax - 51.0
        //maxNumberOfBlackHoles - 11
        //currentRadiusMin - 25.0
        //minNumberOfBlackHoles - 5
        //minTimeBlackHolesLast - 1
        //maxTimeBlackHolesLast - 11
        
        switch true {
        case currentTime >= 0 && currentTime <= 10:
            self.currentRadiusMax = 12.0
            self.currentMaxOfBlackHoles = 6
            self.currentRadiusMin = 6.0
            self.currentMinOfBlackHoles = 2
            self.currentMinTimeBlackHolesLast = 3
            self.currentMaxTimeBlackHolesLast = 7
            self.progressAddition = 0.01
            self.progressSubtraction = 0.01
            self.progressGemValue = 0.1
        case currentTime > 10 && currentTime <= 30:
            self.currentRadiusMax = 15.0
            self.currentMaxOfBlackHoles = 6
            self.currentRadiusMin = 8.0
            self.currentMinOfBlackHoles = 2
            self.currentMinTimeBlackHolesLast = 3
            self.currentMaxTimeBlackHolesLast = 7
            self.progressAddition = 0.005
            self.progressSubtraction = 0.02
            self.progressGemValue = 0.11
        case currentTime > 30 && currentTime <= 60:
            self.currentRadiusMax = 20.0
            self.currentMaxOfBlackHoles = 7
            self.currentRadiusMin = 10.0
            self.currentMinOfBlackHoles = 3
            self.currentMinTimeBlackHolesLast = 3
            self.currentMaxTimeBlackHolesLast = 7
            self.progressAddition = 0.0025
            self.progressSubtraction = 0.03
            self.progressGemValue = 0.12
        case currentTime > 60 && currentTime <= 90:
            self.currentRadiusMax = 25.0
            self.currentMaxOfBlackHoles = 8
            self.currentRadiusMin = 12.0
            self.currentMinOfBlackHoles = 3
            self.currentMinTimeBlackHolesLast = 2
            self.currentMaxTimeBlackHolesLast = 8
            self.progressAddition = 0.001
            self.progressSubtraction = 0.04
            self.progressGemValue = 0.13
        case currentTime > 90 && currentTime <= 120:
            self.currentRadiusMax = 30.0
            self.currentMaxOfBlackHoles = 9
            self.currentRadiusMin = 15.0
            self.currentMinOfBlackHoles = 3
            self.currentMinTimeBlackHolesLast = minTimeBlackHolesLast
            self.currentMaxTimeBlackHolesLast = 9
            self.progressAddition = 0.0005
            self.progressSubtraction = 0.06
            self.progressGemValue = 0.15
        case currentTime > 120 && currentTime <= 180:
            self.currentRadiusMax = 35.0
            self.currentMaxOfBlackHoles = 10
            self.currentRadiusMin = 18.0
            self.currentMinOfBlackHoles = 4
            self.currentMinTimeBlackHolesLast = minTimeBlackHolesLast
            self.currentMaxTimeBlackHolesLast = 10
            self.progressAddition = 0.00025
            self.progressSubtraction = 0.08
            self.progressGemValue = 0.16
        case currentTime > 180 && currentTime <= 240:
            self.currentRadiusMax = 40.0
            self.currentMaxOfBlackHoles = 10
            self.currentRadiusMin = 20.0
            self.currentMinOfBlackHoles = finalMinOfBlackHoles
            self.currentMinTimeBlackHolesLast = minTimeBlackHolesLast
            self.currentMaxTimeBlackHolesLast = 10
            self.progressAddition = 0.0001
            self.progressSubtraction = 0.1
            self.progressGemValue = 0.17
        case currentTime > 240 && currentTime <= 300:
            self.currentRadiusMax = 45.0
            self.currentMaxOfBlackHoles = finalMaxOfBlackHoles
            self.currentRadiusMin = 23.0
            self.currentMinOfBlackHoles = finalMinOfBlackHoles
            self.currentMinTimeBlackHolesLast = minTimeBlackHolesLast
            self.currentMaxTimeBlackHolesLast = maxTimeBlackHolesLast
            self.progressAddition = 0.00005
            self.progressSubtraction = 0.15
            self.progressGemValue = 0.18
        case currentTime > 300:
            self.currentRadiusMax = endingRadiusMax
            self.currentMaxOfBlackHoles = finalMaxOfBlackHoles
            self.currentRadiusMin = endingRadiusMin
            self.currentMinOfBlackHoles = finalMinOfBlackHoles
            self.currentMinTimeBlackHolesLast = minTimeBlackHolesLast
            self.currentMaxTimeBlackHolesLast = maxTimeBlackHolesLast
            self.doNotProgressGameFurther = true
            self.progressAddition = 0.0
            self.progressSubtraction = 0.2
            self.progressGemValue = 0.20
        default:
            break
        }
    }
    
    //Generates black holes.
    func generateBlackHole(){
        
        //Change this code to animation, letting user know where black hole will spawn. 
        //Then add a time delay for the black hole to spawn while the animation is occurring
        
        //Random coordinate value generator
        let operandX: UInt32 = UInt32(self.size.width)/2
        let operandY: UInt32 = UInt32(self.size.height)/2
        
        var randomCoordinateX = Int(arc4random_uniform(operandX)) - Int(arc4random_uniform(operandX))
        var randomCoordinateY = Int(arc4random_uniform(operandY)) - Int(arc4random_uniform(operandY))
            
        randomCoordinateX = Int(arc4random_uniform(operandX)) - Int(arc4random_uniform(operandX))
        randomCoordinateY = Int(arc4random_uniform(operandY)) - Int(arc4random_uniform(operandY))
        
        //Random time range value generator
        let randomTime = Int(arc4random_uniform(UInt32(currentMaxTimeBlackHolesLast-currentMinTimeBlackHolesLast))) + currentMinTimeBlackHolesLast
        
        //Random radius generator
        let randomRadius = CGFloat(arc4random_uniform(UInt32(currentRadiusMax-currentRadiusMin))) + currentRadiusMin
        
        let bounds: CGPoint = CGPoint(x: CGFloat(randomCoordinateX), y: CGFloat(randomCoordinateY))
        let blackHole: BlackHole = BlackHole(circleOfRadius: randomRadius, bounds: bounds, time: randomTime)
        
        
        //Add spawning code here
        
        let particleEmitter = newMagicParticleNode()
        particleEmitter!.particleBirthRate = 20.0
        particleEmitter!.particleLifetime = randomRadius
        particleEmitter!.position = CGPoint(x: randomCoordinateX+Int((randomRadius)), y: randomCoordinateY+Int((randomRadius)))
        self.addChild(particleEmitter!)
        
        
        //Delay before black holes spawn
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0, execute: {
            self.blackHoles.append(blackHole)
            particleEmitter!.particleBirthRate = 0
            self.addChild(blackHole)
        })
        
        //Delay to update number of black holes after black hole destruction
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+Double(randomTime), execute: {
            self.currentNumberOfHoles -= 1
        })
    }
    
    //Updates progress bar
    @objc func updateProgressBar(){
        
        if (self.pauseTimers){
            self.progressBarTimer?.invalidate()
        }
        
        //Add this code to new timer
        
        if (GameScene.spaceShipEngineActive){
            progressValue -= progressSubtraction //Add upgradeable value
        }else{
            progressValue += progressAddition //Add upgradeable value
        }
        
        if (progressValue < 0.0){
            progressValue = 0.0
        }
        if (progressValue > 1.0){
            progressValue = 1.0
        }
        
        //Updates spaceship movement ability
        if (progressValue <= 0.0){
            GameScene.spaceShipEngineActive = false
            spaceShip?.texture = SKTexture(imageNamed: "SpaceShipNoFlame")
            stopFlameSound()
        }
        
        fuelQuantity = Shapes(frame: shapeRect!)
        mainSubview?.willRemoveSubview(fuelQuantity!)
        fuelQuantity?.progress = progressValue
        mainSubview?.addSubview(fuelQuantity!)
        
        //Add this code to new timer
        
        GameScene.score += Int(self.distanceTraveled)
    }
    
    //Delete black hole.
    @objc func updateAll(){
        
        if (self.pauseTimers){
            timer?.invalidate()
        }
        
        self.scaleFactor += 0.1
        
        self.currentTime += 1
        var index = 0
        
        self.distanceTraveled = CGFloat(self.currentTime)*self.scaleFactor
        
        print("\(self.currentTime)")
        
        for hole in blackHoles{
            if hole.pastTime == nil{
                hole.pastTime = currentTime
            }else if (currentTime - hole.pastTime!) >= hole.time!{
                hole.removeFromParent()
                blackHoles.remove(at: index)
                self.currentRandom = Int(arc4random_uniform(UInt32(currentMaxOfBlackHoles-currentMinOfBlackHoles))) + currentMinOfBlackHoles
                index -= 1
            }
            index += 1
        }
        var index1 = 0
        
        for gem in gems{
            if gem.pastTime == nil{
                gem.pastTime = currentTime
            }else if (currentTime - gem.pastTime!) >= gem.time!{
                gem.removeFromParent()
                gems.remove(at: index1)
                self.currentRandom = Int(arc4random_uniform(3)) + 2
                index1 -= 1
            }
            index1 += 1
        }
    }
    
    //Generates gems. 
    func generateGem(){
        
        let operandX: UInt32 = UInt32(self.size.width)/2
        let operandY: UInt32 = UInt32(self.size.height)/2
        
        let randomCoordinateX = Int(arc4random_uniform(operandX)) - Int(arc4random_uniform(operandX))
        let randomCoordinateY = Int(arc4random_uniform(operandY)) - Int(arc4random_uniform(operandY))
        
        //Random time range value generator
        let randomTime = Int(arc4random_uniform(3)) + 2
        
        //Random radius generator
        let radius: CGFloat = 10.0
        
        let bounds: CGPoint = CGPoint(x: CGFloat(randomCoordinateX), y: CGFloat(randomCoordinateY))
        let gem: Gem = Gem(circleOfRadius: radius, bounds: bounds, time: randomTime)
        gems.append(gem)
        self.addChild(gem)
    }
    
    //Plays button sound
    func playButtonSound(){
        
        do{
            player = try AVAudioPlayer(contentsOf: audioButtonFileURL)
            
            player.prepareToPlay()
            player.play()
            
        } catch _{
        }
    }
    
    //Start flame sound
    func playFlameSound(){
        
        GameScene.spaceShipEngineActive = true
        
        do{
            player1 = try AVAudioPlayer(contentsOf: audioFlameFileURL)
        
            player1.prepareToPlay()
            player1.numberOfLoops = 10
            player1.play()
            
        } catch _{
        }
    }
    
    //Stops flame sound
    func stopFlameSound(){
        
        GameScene.spaceShipEngineActive = false
        
        do{
            player1 = try AVAudioPlayer(contentsOf: audioFlameFileURL)
            
            player1.prepareToPlay()
            player1.numberOfLoops = 10
            player1.stop()
            
        } catch _{
        }
    }
    
    //Plays bing sound
    func playBingSound(){
        
        do{
            player2 = try AVAudioPlayer(contentsOf: audioBingFileURL)
            
            player2.prepareToPlay()
            player2.play()
            
        } catch _{
        }
    }
    
    //Generates magic particle type
    func newMagicParticleNode() -> SKEmitterNode?{
        return SKEmitterNode(fileNamed: "MyParticle.sks")
    }
}

//Two black holes can intersect
//Black holes will appear at random places in the wormhole
//Each black hole will last between 2 and 5 seconds initially
//All of this updates as game time increases with updateGameProgress()

class BlackHole: SKShapeNode, SKPhysicsContactDelegate{
    
    var radius: CGFloat?
    var time: Int?
    var pastTime: Int?
    var bounds: CGPoint?
    
    //Class initializer
    init(circleOfRadius: CGFloat, bounds: CGPoint, time: Int) {
        super.init()
        
        let diameter = circleOfRadius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: bounds, size: CGSize(width: diameter, height: diameter)), transform: nil)
        
        self.bounds = bounds
        
        self.time = time
        
        self.fillColor = UIColor.black
        self.radius = circleOfRadius
        
        self.physicsBody?.isDynamic = false
        
        self.physicsBody? = SKPhysicsBody(circleOfRadius: radius!)
    }
    
    //Required for subclassing
    required init?(coder aDecoder: NSCoder) {
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
}

class Gem: SKShapeNode, SKPhysicsContactDelegate {
    
    var radius: CGFloat?
    var time: Int?
    var pastTime: Int?
    var bounds: CGPoint?
    
    //Class initializer
    init(circleOfRadius: CGFloat, bounds: CGPoint, time: Int) {
        super.init()
        
        let diameter = circleOfRadius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: bounds, size: CGSize(width: diameter, height: diameter)), transform: nil)
        
        self.bounds = bounds
        
        self.time = time
        
        self.fillColor = UIColor.blue
        self.radius = circleOfRadius
        
        self.physicsBody?.isDynamic = false
        
        //Alpha mask.
        self.physicsBody? = SKPhysicsBody(circleOfRadius: radius!)
    }
    
    //Required for subclassing
    required init?(coder aDecoder: NSCoder) {
        super.init()
        fatalError("init(coder:) has not been implemented")
    }
}

class Shapes: UIView{
    
    var progressIndicatorFrame: CGRect?
    var progressTrackActivePath: UIBezierPath?
    var activeProgressFrame: CGRect?
    var progressIndicatorWidth: CGFloat?
    var progressIndicatorHeight: CGFloat?
    var progressIndicatorX: CGFloat?
    var progressIndicatorY: CGFloat?
    static var newWidth: CGFloat?
    var progressTrackRect: CGRect?
    var progressTrackPath: UIBezierPath?
    var activeColor: UIColor?
    var progress: CGFloat = 1.0
    
    //Draws the fuel tank
    //static func drawProgressBar(){
    override func draw(_ rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }
        
        //// Color Declarations
        let outerRectGradientColor = UIColor(red: 0.322, green: 0.322, blue: 0.322, alpha: 1.000)
        let outerRectGradientColor3 = UIColor(red: 0.416, green: 0.416, blue: 0.416, alpha: 1.000)
        let shadowColor = UIColor(red: 0.200, green: 0.200, blue: 0.200, alpha: 1.000)
        let lightShadowColor = UIColor(red: 0.671, green: 0.671, blue: 0.671, alpha: 1.000)
        let progressTrackFillColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1.000)
        let progressTrackFillColor3 = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1.000)
        activeColor = UIColor(red: 0.000, green: 0.886, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let outerRectGradient = CGGradient(colorsSpace: nil, colors: [outerRectGradientColor.cgColor, outerRectGradientColor3.cgColor] as CFArray, locations: [0, 1])!
        let progressTrackFill = CGGradient(colorsSpace: nil, colors: [progressTrackFillColor.cgColor, progressTrackFillColor3.cgColor] as CFArray, locations: [0, 1])!
        
        //// Shadow Declarations
        let darkShadow = NSShadow()
        darkShadow.shadowColor = shadowColor
        darkShadow.shadowOffset = CGSize(width: 3, height: 3)
        darkShadow.shadowBlurRadius = 5
        let lightShadow = NSShadow()
        lightShadow.shadowColor = lightShadowColor
        lightShadow.shadowOffset = CGSize(width: 3, height: 3)
        lightShadow.shadowBlurRadius = 5
        
        //// ProgressBar
        //// Border Drawing
        
        //Define variables borderHeight, borderWidth
        let borderHeight = GameScene.fuelQuantityHeight-2
        let borderWidth = GameScene.fuelQuantityWidth-4
        
        let borderPath = UIBezierPath(roundedRect: CGRect(x: 2, y: 1, width: borderWidth, height: borderHeight), cornerRadius: 4)
        context.saveGState()
        context.setShadow(offset: darkShadow.shadowOffset, blur: darkShadow.shadowBlurRadius, color: (darkShadow.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        borderPath.addClip()
        context.drawLinearGradient(outerRectGradient, start: CGPoint(x: 160, y: 1), end: CGPoint(x: 160, y: 35), options: [])
        context.endTransparencyLayer()
        
        //// Frames
        //let progressIndicatorFrame = CGRect(x: 12, y: 10, width: 292, height: 14
        
        //Define variables progressIndicatorX, progressIndicatorY, progressIndicatorWidth, and progressIndicatorHeight
        progressIndicatorWidth = (9/10)*borderWidth
        progressIndicatorHeight = (5/18)*borderHeight
        progressIndicatorX = (borderWidth-progressIndicatorWidth!)/2
        progressIndicatorY = (borderHeight-progressIndicatorHeight!)/2
        
        progressIndicatorFrame = CGRect(x: progressIndicatorX!, y: progressIndicatorY!, width: progressIndicatorWidth!, height: progressIndicatorHeight!)
        
        //// Subframes
        let progressActiveGroup: CGRect = CGRect(x: progressIndicatorFrame!.minX + 2, y: progressIndicatorFrame!.minY + 2, width: progressIndicatorFrame!.width - 4, height: progressIndicatorHeight!)
        activeProgressFrame = CGRect(x: progressActiveGroup.minX + fastFloor(progressActiveGroup.width * 0.00000 + 0.5), y: progressActiveGroup.minY, width: fastFloor(progressActiveGroup.width * 1.00000 + 0.5) - fastFloor(progressActiveGroup.width * 0.00000 + 0.5), height: progressIndicatorHeight!)
        
        ////// Border Inner Shadow
        context.saveGState()
        context.clip(to: borderPath.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((lightShadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let borderOpaqueShadow = (lightShadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: lightShadow.shadowOffset, blur: lightShadow.shadowBlurRadius, color: borderOpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        borderOpaqueShadow.setFill()
        borderPath.fill()
        
        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        //// ProgressTrack Drawing
        progressTrackRect = CGRect(x: (progressIndicatorFrame?.minX)!, y: (progressIndicatorFrame?.minY)!, width: (progressIndicatorFrame?.width)!, height: progressIndicatorHeight!+4)
        progressTrackPath = UIBezierPath(roundedRect: progressTrackRect!, cornerRadius: 7)
        context.saveGState()
        context.setShadow(offset: lightShadow.shadowOffset, blur: lightShadow.shadowBlurRadius, color: (lightShadow.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        progressTrackPath?.addClip()
        context.drawLinearGradient(progressTrackFill,
                                   start: CGPoint(x: (progressTrackRect?.midX)!, y: (progressTrackRect?.minY)!),
                                   end: CGPoint(x: (progressTrackRect?.midX)!, y: (progressTrackRect?.maxY)!),
                                   options: [])
        context.endTransparencyLayer()
        
        ////// ProgressTrack Inner Shadow
        context.saveGState()
        context.clip(to: (progressTrackPath?.bounds)!)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((darkShadow.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let progressTrackOpaqueShadow = (darkShadow.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: darkShadow.shadowOffset, blur: darkShadow.shadowBlurRadius, color: progressTrackOpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        progressTrackOpaqueShadow.setFill()
        progressTrackPath?.fill()
        
        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()
        
        
        //// ProgressActiveGroup
        //// ProgressTrackActive Drawing
        let width = (activeProgressFrame?.width)!*self.progress
        //print("\(self.progress)")
        progressTrackActivePath = UIBezierPath(roundedRect: CGRect(x: (activeProgressFrame?.minX)!, y: (activeProgressFrame?.minY)!, width: width, height: progressIndicatorHeight!), cornerRadius: 5)
        activeColor!.setFill()
        progressTrackActivePath!.fill()
        
    }
}



