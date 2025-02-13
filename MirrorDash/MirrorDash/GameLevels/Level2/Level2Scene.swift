import SpriteKit

class level2Scene: SKScene, SKPhysicsContactDelegate {
    private var blueBall: SKSpriteNode!
    private var pinkBall: SKSpriteNode!

    private var rightline: SKSpriteNode!
    private var leftline: SKSpriteNode!
    
    private var endLineRight: SKSpriteNode!
    private var endLineLeft: SKSpriteNode!
    
    private var bricks: [SKSpriteNode] = []
    private var coins: [SKSpriteNode] = []
    
    private var finishOverlay: SKSpriteNode!
    private var finishPopUp: SKSpriteNode!
    
    private var winCoins: SKSpriteNode!
    private var winCoinsLabel: SKLabelNode!
    
    private var collectedCoinsCount = 0
    
    override func didMove(to view: SKView) {
        setupScene()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleJump),
            name: NSNotification.Name("JumpButtonPressed"),
            object: nil
        )
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveLines()
        checkCollisionWithBricks()
        checkCollisionWithCoins()
        checkCollisionWithFinish()
    }
    
    private func setupScene() {
        self.backgroundColor = .clear
        
        self.rightline = self.childNode(withName: "rightline") as? SKSpriteNode
        self.leftline = self.childNode(withName: "leftline") as? SKSpriteNode
        
        self.pinkBall = self.childNode(withName: "pinkBall") as? SKSpriteNode
        self.pinkBall.addGlow()
        self.blueBall = self.childNode(withName: "blueBall") as? SKSpriteNode
        self.blueBall.addGlow()
        
        self.endLineRight = rightline.childNode(withName: "endLineRight") as? SKSpriteNode
        self.endLineLeft = leftline.childNode(withName: "endLineLeft") as? SKSpriteNode
        
        self.bricks = (rightline.children + leftline.children).compactMap { $0 as? SKSpriteNode }.filter { $0.name?.contains("brick") ?? false }
        
        self.coins = (rightline.children + leftline.children).compactMap { $0 as? SKSpriteNode }.filter { $0.name?.contains("coin") ?? false }
        self.coins.forEach { $0.addGlow(radius: 10) }
    }
    
    private func moveLines() {
        let moveSpeed: CGFloat = 3.0
        rightline.position.x -= moveSpeed
        leftline.position.x += moveSpeed
    }
    
    @objc private func handleJump() {
        jumpBall(blueBall, up: true)
        jumpBall(pinkBall, up: false)
    }
    
    private func jumpBall(_ ball: SKSpriteNode, up: Bool) {
        let jump = SKAction.moveBy(x: 0, y: up ? 100 : -100, duration: 0.3)
        let fall = SKAction.moveBy(x: 0, y: up ? -100 : 100, duration: 0.3)
        let sequence = SKAction.sequence([jump, fall])
        ball.run(sequence)
    }
    
    private func checkCollisionWithBricks() {
        for brick in bricks {
            let brickWorldFrame = brick.parent?.convert(brick.position, to: self) ?? brick.position
            if blueBall.frame.contains(brickWorldFrame) || pinkBall.frame.contains(brickWorldFrame) {
                self.showFinishLevelPopUp(result: .loose)
                self.isPaused = true
            }
        }
    }
    
    private func checkCollisionWithCoins() {
        for coin in coins {
            let coinWorldFrame = coin.parent?.convert(coin.position, to: self) ?? coin.position
            if blueBall.frame.contains(coinWorldFrame) || pinkBall.frame.contains(coinWorldFrame) {
                coin.removeFromParent()
                collectedCoinsCount += 1
                print("Coin collected! Total: \(collectedCoinsCount)")
            }
        }
        coins.removeAll { $0.parent == nil }
    }
    
    private func checkCollisionWithFinish() {
        let endLineRightWorldFrame = endLineRight.parent?.convert(endLineRight.frame, to: self) ?? endLineRight.frame
        let endLineLeftWorldFrame = endLineLeft.parent?.convert(endLineLeft.frame, to: self) ?? endLineLeft.frame

        if blueBall.frame.intersects(endLineRightWorldFrame) {
            self.showFinishLevelPopUp(result: .success)
            self.isPaused = true
        }
        if pinkBall.frame.intersects(endLineLeftWorldFrame) {
            self.showFinishLevelPopUp(result: .success)
            self.isPaused = true
        }
    }

    private func showFinishLevelPopUp(result: GameResult) {
        saveTotalCoins()
        if result == .success {
            UserDefaults.standard.set(2, forKey: "finishedLevel")
        }
        finishOverlay = SKSpriteNode(imageNamed: result == .success ? Asset.winBackground.name : Asset.looseBackgroung.name)
        finishOverlay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        finishOverlay.size = self.size
        finishOverlay.zPosition = 5
        self.addChild(finishOverlay)
        
        self.winCoinsLabel = SKLabelNode(text: "\(collectedCoinsCount)")
        winCoinsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
        winCoinsLabel.fontName = FontFamily.Impact.regular.name
        winCoinsLabel.fontSize = 60
        finishOverlay.addChild(winCoinsLabel)

        winCoins = SKSpriteNode(imageNamed: Asset.Objects.coin.name)
        winCoins.xScale = 2
        winCoins.yScale = 2
        winCoins.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        finishOverlay.addChild(winCoins)
        
           NotificationCenter.default.post(
               name: NSNotification.Name("GameFinished"),
               object: nil,
               userInfo: ["result": result]
           )
    }
    
    private func saveTotalCoins() {
        let storedCoins = UserDefaults.standard.integer(forKey: "totalCoins")
        let newToatal = storedCoins + collectedCoinsCount
        UserDefaults.standard.set(newToatal, forKey: "totalCoins")
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

