//
//  ViewController.swift
//  FirstARApp
//
//  Created by vijayvir on 13/04/2021.
//

import UIKit
import RealityKit
import ARKit
class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var anchorName = "Experience1"
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.session.delegate = self
        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
//
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
    
           setupArView()
               
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(onTap))
              arView.addGestureRecognizer(tapGesture)
        
    
    }
    
 @objc func onTap(_ sender: UITapGestureRecognizer){
        
    let location = sender.location(in: arView)
 
    let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
    
    if let firstResult = results.first{
        let anchor = ARAnchor(name: anchorName , transform : firstResult.worldTransform)
        arView.session.add(anchor:anchor)
        
    }else {
        print("Object placement failed - couldnt find the surface")
        
    }
 
 
 }
    
    //MARK: Setup ARView
    
    func setupArView(){
        
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        
        
    }
    
}
extension ViewController : ARSessionDelegate{
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName1 = anchor.name , anchorName1  == anchorName {
                placeObject(named: anchorName1 , for : anchor)
            }
        }
    }
    
    
    func placeObject(named EntityName : String , for anchor : ARAnchor){
        let entity = try! ModelEntity.loadAnchor(named: EntityName)
        entity.generateCollisionShapes(recursive: true )

       // arView.installGestures([.rotation,.translation] , for : entity as! Entity & HasCollision)
        
        let anchorEntity = AnchorEntity(anchor:anchor)
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
        
        
    }
}
