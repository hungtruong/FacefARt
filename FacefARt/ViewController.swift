//
//  ViewController.swift
//  FacefARt
//
//  Created by Hung Truong on 11/3/17.
//  Copyright © 2017 Hung Truong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    /// This is the ARSCNView that we use to get the AR session and face anchor data from
    @IBOutlet weak var sceneView: ARSCNView!
    
    /// This is the fart sound player. It gets loaded on viewDidLoad and replaced for each new fart play
    var fartPlayer : AVAudioPlayer?
    
    /// Tracks when the mouth has opened and when it's closed
    var mouthOpen : Bool = false
    
    /// The data asset for the fart sound, reusing it for efficiency.
    lazy var fartDataAsset : NSDataAsset? = {
        return NSDataAsset(name: "Fart")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If Face Tracking isn't supported then just return
        guard ARFaceTrackingConfiguration.isSupported else { return }
        
        // Set up a face tracking configuration and then start a session with it.
        let configuration = ARFaceTrackingConfiguration()
        sceneView.delegate  = self
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        //Pretty self explanatory. Sets up the fart sound player for the first fart.
        prepareToFart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Delegate method that updates the ARFaceAnchor data as it comes in thru the session.
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        // There are a bunch of faceAnchor properties but we only care about the mouth opening for this app.
        // Strangely, its' called "mouthClose" but 0 is closed and 1 is open... Shouldn't it be the other way around?
        if let mouthOpenness = faceAnchor.blendShapes[ARFaceAnchor.BlendShapeLocation.mouthClose]?.doubleValue {
            // The value given here ranges from really low to somewhat low, not sure if it could ever get to 1.0
            // So 0.045 seems like a decent number to catch the open mouth but miss some false positives /shrug
            if mouthOpenness > 0.045 {
                handleMouthOpen()
            } else {
                handleMouthClosed()
            }
        }
    }

    /// Handle the mouth opening, if the mouth is already open then just return early
    func handleMouthOpen() {
        guard !mouthOpen else { return }
        mouthOpen = true
        startFarting()
    }
    
    /// Opposite of the mouth opening func
    func handleMouthClosed() {
        guard mouthOpen else { return }
        mouthOpen = false
        stopFarting()
    }
    
    /// This just gets the fart player ready. I guess if I didn't do this the fart sound might be a little delayed. Gotta get those fart buffers ready.
    func prepareToFart() {
        guard let fartDataAsset = fartDataAsset else { return }
        do {
        fartPlayer = try AVAudioPlayer(data:fartDataAsset.data, fileTypeHint:"mp3")
        fartPlayer?.prepareToPlay()
        } catch {
            
        }
    }
    
    /// Starts the fart player's sound (which is a fart sound)
    func startFarting() {
        guard let fartPlayer = fartPlayer else { return }
        fartPlayer.play()
    }
    
    /// If the person closes their mouth, the fart sound stops prematurely, then gets another fart player ready.
    func stopFarting() {
        guard let fartPlayer = fartPlayer else { return }
        fartPlayer.stop()
        prepareToFart()
    }
    
}

