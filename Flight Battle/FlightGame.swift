//
//  GameScene.swift
//  Flight Battle
//
//  Created by CaiYang on 4/21/19.
//  Copyright © 2019 CaiYang. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    /////////////////Global setting
    ////////Lables
    
    let scoreLable = SKLabelNode(fontNamed: "The Bold Font" )
    
    var levelNumber = 0
    
    var livesNumber = 3
    
    var bossLife = 10
    
    let livesLable = SKLabelNode(fontNamed: "The Bold Font")
    
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    
    
    let player = SKSpriteNode(imageNamed: "ship 3")
    let bulletSound = SKAction.playSoundFileNamed("bsound", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("boom", waitForCompletion: false)
    
    
    /////////Game state
    enum gameState{
        case preGame ////Before the game started
        case inGame  ////During the game
        case afterGame ////After the game
    }
    
    var currentGameState = gameState.preGame
    
    //var x = UInt32(yourInt)
    
    ///////////physical bodies
    struct PhysicsCategories {
        static let None : UInt32 = UInt32(0)
        static let player : UInt32 = UInt32(1) //0b1 //1
        static let bullet : UInt32 = UInt32(2)//0b10 //2
        
        static let missile : UInt32 = UInt32(3)//0b101 //
        
        static let enemy : UInt32 = UInt32(4)//0b100 //4
        static let Boss : UInt32 = UInt32(5)//0b1000 // 8
        
    }
    
    /////////////Lock game area
    var gameArea: CGRect
    override init(size: CGSize) {
        
        let maxShipRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxShipRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        super.init(size:size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        /////////////////////background
        
        
        for i in 0...1{
            
        
        let background = SKSpriteNode(imageNamed: "Background 1")
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x:  self.size.width/2, y: self.size.height*CGFloat(i))
        background.zPosition = 0
            
        background.name = "background1"
        self.addChild(background)
            
            
        }
        
        /////////////////////player
        /////let player = SKSpriteNode(imageNamed: "ship")
        player.setScale(0.3)
        //player.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        
        
        player.zPosition=2
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.enemy | PhysicsCategories.Boss
        
        self.addChild(player)
        
        //////////////////score lable
        scoreLable.text = "Score: 0"
        scoreLable.fontSize = 70
        scoreLable.color = SKColor.white
        scoreLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLable.position = CGPoint(x: self.size.width*0.2, y: self.size.height + scoreLable.frame.size.height)
        scoreLable.zPosition = 10
        self.addChild(scoreLable)
        
        
        
        /////////////////Lives  lable
        livesLable.text = "Lives: 3"
        livesLable.fontSize = 70
        livesLable.color = SKColor.white
        livesLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLable.position = CGPoint(x: self.size.width*0.6, y: self.size.height + livesLable.frame.size.height)
        livesLable.zPosition = 10
        self.addChild(livesLable)
        
        
        
        
        
        tapToStartLabel.text = "Tap to start"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        startNewLevel()
        
        
        
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "background1"){
            background, stop in
            if self.currentGameState == gameState.inGame{
            background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
                
            }
            
        }
        
        
        
    }
    
    
    
    
    //////////////////Add score
    func addScore(){
        
        gameScore += 1
        scoreLable.text = "score: \(gameScore)"
        
        if gameScore == 5 || gameScore == 10 || gameScore == 15{
            startNewLevel()
        }
        
       
    }
    
    
    
    /////////Game Over
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "bullet1"){
            bullet, stop in
            bullet.removeAllActions()
            
        }
        self.enumerateChildNodes(withName: "enemy1"){
            enemy, stop in
            enemy.removeAllActions()
            
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChange = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([changeSceneAction, waitToChange])
        self.run(changeSceneSequence)
        
    }
    
    ////////////start game
    func startGame(){
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeIn(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnTheScene = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startMoveShipSequence = SKAction.sequence([moveShipOnTheScene,startLevelAction])
        player.run(startMoveShipSequence)
        
        let moveOnToTheScene = SKAction.moveTo(y: self.size.height*0.9, duration: 0.5)
        scoreLable.run(moveOnToTheScene)
        livesLable.run(moveOnToTheScene)
        fire()
    }
    
    
    
    
    ///////////////Lose lives
    func loseALife(){
        livesNumber -= 1
        livesLable.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.3)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLable.run(scaleSequence)
        
      
        
        if livesNumber == 0{
            runGameOver()
        }
    }
    
    
    
    
   /////////////////bullet
    func fire() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.name = "bullet1"
        
        bullet.setScale(0.1)
        bullet.position = player.position
        bullet.zPosition=1
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.enemy | PhysicsCategories.Boss
        
        self.addChild(bullet)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletsequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        bullet.run(bulletsequence)
        
    }
    
    
    //////////////////////enemy
    func spawnShip(){
        let num = CGFloat.random(in: 1...100)
        let randomXstart = (num / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num1 = CGFloat.random(in: 1...100)
        let randomXend = (num1 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let startPoint = CGPoint(x: randomXstart, y: self.size.height * 1.2)
        let endPoint =  CGPoint(x: randomXend, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "ship 1")
        
        enemy.name = "enemy1"
        
        enemy.setScale(0.3)
        enemy.position = startPoint
        enemy.zPosition=2
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.bullet
        
        self.addChild(enemy)
        
        /////////////Enemy move
        let moveEnemy1 = SKAction.move(to: endPoint, duration: 3)
        let deleteEnemy = SKAction.removeFromParent()
        
        //////Enemy get the bottom of the screen, lose 1 life
       // let loseALifeAction = SKAction.run(loseALife)
        // let enemySequence = SKAction.sequence([moveEnemy1, deleteEnemy,loseALifeAction])
        let enemySequence = SKAction.sequence([moveEnemy1, deleteEnemy])
        
        if currentGameState == gameState.inGame{
        enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotated = atan2(dy, dx)
        enemy.zRotation = amountToRotated
        
    }
    ////////Boss
    func spawnBoss(){
        let numStart = CGFloat.random(in: 1...100)
        let randomXstart = (numStart / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num1 = CGFloat.random(in: 1...100)
        let randomXmid1 = (num1 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num2 = CGFloat.random(in: 1...100)
        let randomXmid2 = (num2 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num3 = CGFloat.random(in: 1...100)
        let randomXmid3 = (num3 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num4 = CGFloat.random(in: 1...100)
        let randomXmid4 = (num4 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num5 = CGFloat.random(in: 1...100)
        let randomXmid5 = (num5 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let num6 = CGFloat.random(in: 1...100)
        let randomXmid6 = (num6 / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        let numEnd = CGFloat.random(in: 1...100)
        let randomXend = (numEnd / 100) * (gameArea.maxX - gameArea.minX)+gameArea.minX
        
        let startPoint = CGPoint(x: randomXstart, y: self.size.height * 1.2)
        let mid1Point = CGPoint(x: randomXmid1, y: self.size.height*0.85)
        let mid2Point = CGPoint(x: randomXmid2, y: self.size.height*0.8)
        let mid3Point = CGPoint(x: randomXmid3, y: self.size.height*0.75)
        let mid4Point = CGPoint(x: randomXmid4, y: self.size.height*0.8)
        let mid5Point = CGPoint(x: randomXmid5, y: self.size.height*0.85)
        let mid6Point = CGPoint(x: randomXmid6, y: self.size.height*0.8)
        let endPoint =  CGPoint(x: randomXend, y: self.size.height * 0.75)
        
        
        let boss = SKSpriteNode(imageNamed: "boss1")
        
        boss.name = "Boss"
        
        boss.setScale(0.75)
        boss.position = startPoint
        boss.zPosition=5
        
        boss.physicsBody = SKPhysicsBody(rectangleOf: boss.size)
        boss.physicsBody!.affectedByGravity = false
        boss.physicsBody!.categoryBitMask = PhysicsCategories.Boss
        boss.physicsBody!.collisionBitMask = PhysicsCategories.None
        boss.physicsBody!.contactTestBitMask = PhysicsCategories.player | PhysicsCategories.bullet
        
        self.addChild(boss)
        
        
        /////////////Boss show
        let showBoss = SKAction.move(to: mid1Point, duration: 2)
        //let deleteEnemy = SKAction.removeFromParent()
        
        //////Enemy get the bottom of the screen, lose 1 life
        // let loseALifeAction = SKAction.run(loseALife)
        // let enemySequence = SKAction.sequence([moveEnemy1, deleteEnemy,loseALifeAction])
        let showBossSequence = SKAction.sequence([showBoss])
        
        if currentGameState == gameState.inGame{
            boss.run(showBossSequence)
        }
        
        ////////////////Boss move
        let moveBoss2 = SKAction.move(to: mid2Point, duration: 5)
        let moveBoss3 = SKAction.move(to: mid3Point, duration: 5)
        let moveBoss4 = SKAction.move(to: mid4Point, duration: 5)
        let moveBoss5 = SKAction.move(to: mid5Point, duration: 5)
        let moveBoss6 = SKAction.move(to: mid6Point, duration: 5)
        let moveBossEnd = SKAction.move(to: endPoint, duration: 5)
        
        let moveBossSequence = SKAction.sequence([moveBoss2, moveBoss3, moveBoss4, moveBoss5, moveBoss6, moveBossEnd])
        
        if currentGameState == gameState.inGame{
           boss.run(SKAction.repeatForever(moveBossSequence))
            
            //enemy.run(SKAction.repeat(SKAction.animate(with: TexureArray1, timePerFrame: 0.1), count: -1))
            
        }
        
        let dx = gameArea.minX - gameArea.maxX
        let dy = gameArea.minY - gameArea.maxY
        let amountToRotated = atan2(dx,100*dy)
        boss.zRotation = amountToRotated
        
       
    }
    
    ///////////////Contact with bodies
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.contactTestBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.player && body2.categoryBitMask == PhysicsCategories.enemy {
            //// if the player has hitted the enemy
            
            if body1.node != nil {
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
           
            loseALife()
            returnToGame()
            
            
            
        }
        if body1.categoryBitMask == PhysicsCategories.bullet && body2.categoryBitMask == PhysicsCategories.enemy {
            //// if the bullet has hitted the enemy
            
            addScore()
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.player && body2.categoryBitMask == PhysicsCategories.Boss {
            //// if the player has hitted the boss
            
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
            
            loseALife()
            returnToGame()
            
            
            
        }
        if body1.categoryBitMask == PhysicsCategories.bullet && body2.categoryBitMask == PhysicsCategories.Boss {
            //// if the bullet has hitted the boss
            loseLifeBoss()
            
           
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            if bossLife == 0{
            body2.node?.removeFromParent()
                addScore()
                addScore()
                addScore()
                addScore()
                addScore()
             
                
            }
        }
        
        
        
        //runGameOver()
    }
    
    
    func loseLifeBoss(){
        
            bossLife -= 1
       
    
    }
    
    
    //////////////Explosion
    func spawnExplosion(spawnPosition:CGPoint){
        let explosion = SKSpriteNode(imageNamed: "Exposion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.8, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
        
        
        
    }
    
    
    //////////////Level system
    func startNewLevel() {
        levelNumber += 1
        
        if self.action(forKey: "spwaningEnemies") != nil {
            self.removeAction(forKey: "spwaningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 3
        case 2: levelDuration = 1.5
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnShip)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSquence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSquence)
        self.run(spawnForever, withKey: "spwaningEnemies")
        
        
        
        
        
        
        
        let shot = SKAction.run (fire)
        let waitToShot = SKAction.wait(forDuration: 1.5)
        let shotSquence = SKAction.sequence([shot, waitToShot])
        let shotForever = SKAction.repeatForever(shotSquence)
        
        
        if currentGameState == gameState.inGame{
            self.run(shotForever)
            
            if gameScore == 10{
                spawnBoss()
            }
            
        }
    }
    
    
    /////////Change Scene
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 1)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
        
    }
    
    
    
    
    
    
    ////////////start game
    func returnToGame(){
        if currentGameState == gameState.inGame {
        
        player.setScale(0.3)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        self.addChild(player)
        let moveShipOnTheScene = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startMoveShipSequence = SKAction.sequence([moveShipOnTheScene,startLevelAction])
        player.run(startMoveShipSequence)
       
            
        }
        
    }
    
    
    
    
    
    
    
    func fire2() {
        
        let bullet = SKSpriteNode(imageNamed: "Bullet-2")
        
        bullet.name = "bullet1"
        
        bullet.setScale(0.1)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y )
        bullet.zPosition=1
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.enemy | PhysicsCategories.Boss
        
       // self.addChild(bullet)
        //let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let scaleLong = SKAction.scaleY(to: 2, duration: 5)
        let scaleDown = SKAction.scaleY(to: 1, duration: 2)
        let deleteBullet = SKAction.removeFromParent()
        let bulletsequence = SKAction.sequence([bulletSound,scaleLong,scaleDown, deleteBullet])
        bullet.run(bulletsequence)
       
        
        
    //let scaleUp = SKAction.scale(to: 1.5, duration: 0.3)
    //let scaleDown = SKAction.scale(to: 1, duration: 0.3)
   // let scaleSequence = SKAction.sequence([scaleLong])
    //livesLable.run(scaleSequence)
    
    }
    
    
    
    
    
    //////////Touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            startGame()
        }
        
        if currentGameState == gameState.inGame{
        //fire2()
            
            
        //spawnBoss()
        }
    }
    
    
    
    
    ///////////////Move on the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountXDragged = pointOfTouch.x-previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
            player.position.x += amountXDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width{
                player.position.x = gameArea.maxX - player.size.width
                
            }
            
            if player.position.x < gameArea.minX + player.size.width{
                player.position.x = gameArea.minX + player.size.width
                
            }
            
            let amountYDragged = pointOfTouch.y-previousPointOfTouch.y
            
            if currentGameState == gameState.inGame{
                player.position.y += amountYDragged
            }
            
            if player.position.y > gameArea.maxY - player.size.width{
                player.position.y = gameArea.maxY - player.size.width
                
            }
            
            if player.position.y < gameArea.minY + player.size.width{
                player.position.y = gameArea.minY + player.size.width
                
            }
            
            
            
            
        
        }
    }
    
    
    
}
