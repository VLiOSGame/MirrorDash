import SpriteKit

class InfinityLevelScene: SKScene, SKPhysicsContactDelegate {
    private var blueBall: SKSpriteNode!
    private var pinkBall: SKSpriteNode!

    private var rightline: SKSpriteNode!
    private var leftline: SKSpriteNode!
    
    private var endLineRight: SKSpriteNode!
    private var endLineLeft: SKSpriteNode!
    
    private var bricks: [SKSpriteNode] = []
    private var coins: [(node: SKSpriteNode, parent: SKNode?)] = []
    
    private var finishOverlay: SKSpriteNode!
    private var finishPopUp: SKSpriteNode!
    
    private var winCoins: SKSpriteNode!
    private var winCoinsLabel: SKLabelNode!
    
    private var collectedCoinsCount = 0
    
    private var initialRightLinePosition: CGPoint = .zero
    private var initialLeftLinePosition: CGPoint = .zero
    private var initialCoinPositions: [CGPoint] = []
    
    override func didMove(to view: SKView) {
        setupScene()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleJump),
            name: NSNotification.Name("JumpButtonPressed"),
            object: nil
        )
        
        initialRightLinePosition = rightline.position
        initialLeftLinePosition = leftline.position
        initialCoinPositions = coins.map { $0.node.position }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveLines()
        checkCollisionWithBricks()
        checkCollisionWithCoins()
    }
    
    private func setupScene() {
        self.backgroundColor = .clear
        
        self.rightline = self.childNode(withName: "rightline") as? SKSpriteNode
        self.leftline = self.childNode(withName: "leftline") as? SKSpriteNode
        
        self.pinkBall = self.childNode(withName: "pinkBall") as? SKSpriteNode
        self.pinkBall.addGlow()
        self.blueBall = self.childNode(withName: "blueBall") as? SKSpriteNode
        self.blueBall.addGlow()
        
        self.bricks = (rightline.children + leftline.children).compactMap { $0 as? SKSpriteNode }.filter { $0.name?.contains("brick") ?? false }
        
        self.coins = (rightline.children + leftline.children).compactMap {
            guard let sprite = $0 as? SKSpriteNode, sprite.name?.contains("coin") ?? false else { return nil }
            return (node: sprite, parent: sprite.parent)
        }
        self.coins.forEach {
            $0.node.addGlow(radius: 10)
            $0.node.zPosition = 10
        }
    }
    
    private func moveLines() {
        let moveSpeed: CGFloat = 3.0
        rightline.position.x -= moveSpeed
        leftline.position.x += moveSpeed
        
        if leftline.position.x >= self.frame.maxX * 2 {
            resetLinesAndCoins()
        }
    }
    
    private func resetLinesAndCoins() {
        rightline.position = initialRightLinePosition
        leftline.position = initialLeftLinePosition
        
        for (index, coinData) in coins.enumerated() {

            coinData.node.position = initialCoinPositions[index]
            coinData.node.zPosition = 10
            coinData.node.alpha = 1.0
            
            if coinData.node.parent == nil, let parent = coinData.parent {
                parent.addChild(coinData.node)
            } else {
                print("Coin \(coinData.node.name ?? "Unnamed") already has a parent")
            }
        }
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
        for coinData in coins {
            let coinWorldFrame = coinData.node.parent?.convert(coinData.node.position, to: self) ?? coinData.node.position
            if blueBall.frame.contains(coinWorldFrame) || pinkBall.frame.contains(coinWorldFrame) {
                coinData.node.alpha = 0
                collectedCoinsCount += 1
            }
        }
    }

    private func showFinishLevelPopUp(result: GameResult) {
        saveTotalCoins()

        finishOverlay = SKSpriteNode(imageNamed: result == .success ? Asset.winBackground.name : Asset.looseBackgroung.name)
        finishOverlay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        finishOverlay.size = self.size
        finishOverlay.zPosition = 5
        self.addChild(finishOverlay)
        
        self.winCoinsLabel = SKLabelNode(text: "\(collectedCoinsCount / 4)")
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
        let newTotal = storedCoins + (collectedCoinsCount / 4)
        UserDefaults.standard.set(newTotal, forKey: "totalCoins")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
