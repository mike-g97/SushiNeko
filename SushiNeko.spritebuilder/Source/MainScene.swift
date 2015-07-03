import Foundation

enum Side {
    case Left, Right, None
}

enum GameState {
    case Title, Ready, Playing, GameOver
}

class MainScene: CCNode {
    weak var piecesNode :CCNode!
    weak var character: Character!
    var pieces : [Piece] = []
    var pieceLastSide: Side = .Left
    var pieceIndex : Int = 0
    var gameState: GameState = .Title
    weak var restartButton: CCButton!
    weak var lifeBar: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var tapButtons: CCNode!

    var score: Int = 0 {
        didSet{
            scoreLabel.string = "\(score)"
        }
    }
    
    var timeLeft: Float = 5 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
        
        for i in 0..<10 {
            var piece = CCBReader.load("Piece") as! Piece
            var yPos = piece.contentSizeInPoints.height * CGFloat(i)
            
            pieceLastSide = piece.setObstacle(pieceLastSide)
            
            piece.position = CGPoint(x: 7, y: yPos)
            piecesNode.addChild(piece)
            pieces.append(piece)
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var xTouch = touch.locationInWorld().x
        var side = CCDirector.sharedDirector().viewSize().width / 2
        
        if gameState == .GameOver || gameState == .Title { return }
        if gameState == .Ready { start() }
        
        if xTouch < side {
            character.left()
        }else{
            character.right()
        }
        
        if isGameOver() { return }
        
        stepTower()
        
        score++
    }
    
    func stepTower(){
        var piece = pieces[pieceIndex]
        
        var yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
        piece.zOrder = piece.zOrder + 1
        
        pieceLastSide = piece.setObstacle(pieceLastSide)
        
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))
        
        pieceIndex = (pieceIndex + 1) % 10
        
        if isGameOver() { return }
        
         timeLeft = timeLeft + 0.25
    }
    
    func triggerGameOver() {
        gameState = .GameOver
        restartButton.visible = true
    }
    
    func isGameOver() -> Bool {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
         return gameState == .GameOver
    }
    
    func restart() {
        var mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.ready()
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    override func update(delta: CCTime) {
        if gameState != .Playing { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
    
    func ready() {
        gameState = .Ready
        
        self.animationManager.runAnimationsForSequenceNamed("Ready")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
    }
    
    func start() {
        gameState = .Playing
        
        tapButtons.runAction(CCActionFadeOut(duration: 0.2))
    }
}
