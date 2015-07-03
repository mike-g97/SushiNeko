import Foundation

enum Side {
    case Left, Right, None
}

class MainScene: CCNode {
    weak var piecesNode :CCNode!
    weak var character: Character!
    var pieces : [Piece] = []
    var pieceLastSide: Side = .Left
    var pieceIndex : Int = 0
    var gameOver = false
    weak var restartButton: CCButton!
    weak var lifeBar: CCSprite!
    weak var scoreLabel: CCLabelTTF!

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
        
        if gameOver { return }
        
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
        gameOver = true
        restartButton.visible = true
    }
    
    func isGameOver() -> Bool {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gameOver
    }
    
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    override func update(delta: CCTime) {
        if gameOver { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
}
