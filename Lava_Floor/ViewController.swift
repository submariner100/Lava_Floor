//
//  ViewController.swift
//  Lava_Floor
//
//  Created by Macbook on 10/10/2017.
//  Copyright © 2017 Lodge Farm Apps. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet weak var sceneView: ARSCNView!
	@IBOutlet weak var planeDetected: UILabel!
	
	let configuration = ARWorldTrackingConfiguration()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
	self.sceneView.autoenablesDefaultLighting = true
	self.configuration.planeDetection = .horizontal
	self.sceneView.session.run(configuration)
	self.sceneView.delegate = self
	
}
	
	func createLava(planeAnchor: ARPlaneAnchor) -> SCNNode {
		let laveNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
		laveNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "lava")
		laveNode.geometry?.firstMaterial?.isDoubleSided = true
		laveNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
		laveNode.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
		return laveNode
		
	}

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		let lavaNode = createLava(planeAnchor: planeAnchor)
		node.addChildNode(lavaNode)
		
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		node.enumerateChildNodes { (childNode, _) in
			childNode.removeFromParentNode()
		}
		let lavaNode = createLava(planeAnchor: planeAnchor)
		node.addChildNode(lavaNode)
	
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		guard let _ = anchor as? ARPlaneAnchor else {return}
		node.enumerateChildNodes { (childNode, _) in
			childNode.removeFromParentNode()
		}
	}
}

extension Int {
	var degreesToRadians: Double { return Double(self) * .pi/180}
	
}

