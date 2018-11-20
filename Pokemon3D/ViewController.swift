//
//  ViewController.swift
//  Pokemon3D
//
//  Created by minami on 2018-11-20.
//  Copyright © 2018 宗像三奈美. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self
    
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true
    
    sceneView.automaticallyUpdatesLighting = true
    
    //        // Create a new scene
    //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
    //
    //        // Set the scene to the view
    //        sceneView.scene = scene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARImageTrackingConfiguration() // track only images
    if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "PokemonCards", bundle: Bundle.main) {
      configuration.trackingImages = imageToTrack
      configuration.maximumNumberOfTrackedImages = 2
    }
    
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  // anchor has the information of the photo
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    let node = SCNNode()
    
    if let imageAnchor = anchor as? ARImageAnchor {
      // when detect the card, place the plane as same as the size of the image
      let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                           height: imageAnchor.referenceImage.physicalSize.height)
      plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
      let planeNode = SCNNode(geometry: plane)
      // rotate (default is vertical)
      planeNode.eulerAngles.x = -.pi / 2 // (pi is 180) / 2 == 90
      node.addChildNode(planeNode)
      
      // character: ditto
      if imageAnchor.referenceImage.name == "ditto" {
        guard let pokeScene = SCNScene(named: "art.scnassets/ditto.scn") else { return nil }
        // have to flatten the scn file
        if let pokeNode = pokeScene.rootNode.childNodes.first {
          // rotate (default is vertical to plane)
          pokeNode.eulerAngles.x = .pi / 2
          planeNode.addChildNode(pokeNode)
        }
      }
      // character: ralts
      if imageAnchor.referenceImage.name == "ralts" {
        guard let pokeScene = SCNScene(named: "art.scnassets/ralts.scn") else { return nil }
        // have to flatten the scn file
        if let pokeNode = pokeScene.rootNode.childNodes.first {
          // rotate (default is vertical to plane)
          pokeNode.eulerAngles.x = .pi / 2
          planeNode.addChildNode(pokeNode)
        }
      }
    }
    
    return node
  }
}
