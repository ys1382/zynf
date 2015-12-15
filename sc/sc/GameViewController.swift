import SceneKit
import QuartzCore


struct Position {
    var x=CGFloat(0), y=CGFloat(0), z=CGFloat(0) // movement
    var a=CGFloat(0), b=CGFloat(0), c=CGFloat(0) // rotation
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func daeToNode(dae:String) -> SCNNode {
    let walking = SCNScene(named: "art.scnassets/" + dae)
    let nodeArray = walking!.rootNode.childNodes
    let node = SCNNode()
    
    for childNode in nodeArray {
        node.addChildNode(childNode as SCNNode)
    }
    node.pivot = SCNMatrix4MakeRotation(CGFloat(M_PI), 0, 1, 0)
    node.hidden = true

    return node
}

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    var idle = daeToNode("idle")
    var guy = daeToNode("walking")
    var leftTurn = daeToNode("left_turn_90")
    var rightTurn = daeToNode("right_turn_90")
    var backwards = daeToNode("walking_backwards")

    var position = Position()

    override func awakeFromNib(){
        sceneB()
    }

    override func moveUp    (sender: AnyObject?) { guyMoveX(0, y:0, z:-150) }
    override func moveDown  (sender: AnyObject?) { guyMoveX(0, y:0, z:50)  }
    override func moveRight (sender: AnyObject?) { guyTurn(-CGFloat(M_PI_2))}
    override func moveLeft  (sender: AnyObject?) { guyTurn(CGFloat(M_PI_2)) }
    
    func place(node0:SCNNode, at:SCNNode) {
        at.hidden = true
        node0.position = at.position
        node0.eulerAngles = at.eulerAngles
        node0.hidden = false
    }
    
    func guyTurn(angle:CGFloat) {
        let figure = ( angle > 0 ? leftTurn : rightTurn )
        place(figure, at:idle)
        delay(0.5) {
            self.idle.eulerAngles.y += angle
            print("idle at \(self.idle.eulerAngles.y), angle = \(angle)")
            figure.hidden = true
            self.idle.hidden = false
        }
    }
    
    func guyMoveX(x:Int, y:Int, z:Int) {

        let g = z < 0 ? guy : backwards
        
        place(g, at:idle)
        let move = localMove(g, x:CGFloat(x), y:CGFloat(y), z:CGFloat(z))
        g.runAction(move, completionHandler: {
            self.place(self.idle, at:g)
        })
    }

    func localMove(node:SCNNode, x:CGFloat, y:CGFloat, z:CGFloat) -> SCNAction {
        
        print("angles = \(node.eulerAngles)")
        let dz = z * cos(node.eulerAngles.y)
        let dx = z * sin(node.eulerAngles.y)
        let dy = z * sin(node.eulerAngles.x)
        print("move \(dx),\(dy),\(dz)")
        
        return SCNAction.moveByX(dx, y:dy, z:dz, duration:1)
    }
    
    func sceneB() {

        self.gameView.scene = SCNScene()

        self.gameView.scene!.rootNode.addChildNode(guy)
        self.gameView.scene!.rootNode.addChildNode(idle)
        self.gameView.scene!.rootNode.addChildNode(rightTurn)
        self.gameView.scene!.rootNode.addChildNode(leftTurn)
        self.gameView.scene!.rootNode.addChildNode(backwards)
        idle.hidden = false

        let plane = SCNPlane(width: 100.0, height: 200.0)
        let floor = SCNNode(geometry: plane)
        floor.pivot = SCNMatrix4MakeRotation(CGFloat(M_PI_2), 1, 0, 0)
        self.gameView!.scene!.rootNode.addChildNode(floor)

//        let sphereGeometry = SCNSphere(radius: 10.0)
//        let sphereNode = SCNNode(geometry: sphereGeometry)
//        self.gameView!.scene!.rootNode.addChildNode(sphereNode)
        
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.blackColor()
    }

    func sceneA() {

        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(SCNVector4: SCNVector4(x: CGFloat(0), y: CGFloat(1), z: CGFloat(0), w: CGFloat(M_PI)*2))
        animation.duration = 3
        animation.repeatCount = MAXFLOAT //repeat forever
        ship.addAnimation(animation, forKey: nil)
        
        // set the scene to the view
        self.gameView!.scene = scene
    }

}
