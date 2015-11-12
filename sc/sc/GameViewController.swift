//
//  GameViewController.swift
//  sc
//
//  Created by Saib, Yusuf on 11/2/15.
//  Copyright (c) 2015 x. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    
    override func awakeFromNib(){
        sceneB()
    }

    override func keyDown(event: NSEvent) {
        super.keyDown(event)
        print("Caught a key down: \(event.keyCode)!")
    }

    func sceneB() {

        self.gameView.scene = SCNScene()

        let walking = SCNScene(named: "art.scnassets/walking")
        let nodeArray = walking!.rootNode.childNodes
        for childNode in nodeArray {
            self.gameView.scene!.rootNode.addChildNode(childNode as SCNNode)
        }
        
        let plane = SCNPlane(width: 100.0, height: 200.0)
        let floor = SCNNode(geometry: plane)
        floor.pivot = SCNMatrix4MakeRotation(CGFloat(M_PI_2), 1, 0, 0)
        self.gameView!.scene!.rootNode.addChildNode(floor)

        let sphereGeometry = SCNSphere(radius: 10.0)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.gameView!.scene!.rootNode.addChildNode(sphereNode)
        
        
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
