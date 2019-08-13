//
//  QRViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 25/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import AVFoundation
import ARKit

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var videoPreview: UIView!
    
    var stringCode : String?
    var objectAppears: Bool = true
    var discoveredQRCodes = [String]()
    
    enum error: Error {
        case NoCameraAvailable
        case VideoInputFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        sceneView.delegate = self
        //sceneView.showsStatistics = true
        let configuration = ARWorldTrackingConfiguration()
        sceneView.preferredFramesPerSecond = 30
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.session.delegate = self
       
        do{
         // try self.scanQRCode()
        } catch{
            
            print("Failed to scan the QR/BarCode.")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            
            if  machineReadableCode?.type == AVMetadataObject.ObjectType.qr{
               self.stringCode = machineReadableCode?.stringValue
                // AÑADIR ACCION CUANDO HEMOS TENIDO EL VALOR DEL QR
                if objectAppears {
                   
                    self.configureLighting()
                    self.addPaperPlane()
                    self.objectAppears = false
                }
                }
            }
    
        }

    func scanQRCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera.")
            throw error.NoCameraAvailable
        }
        
        guard let avCaptureInput =  try? AVCaptureDeviceInput(device: avCaptureDevice) else {
                print("Failed  to init camera")
            throw error.VideoInputFail
        }
        
        let avCaptureMetadataOutput =  AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
    }
    
    //3D Objects
    
    
    func addPaperPlane(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let paperPlaneScene = SCNScene(named: "paperPlane.scn"), let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "paperPlane", recursively: true) else {
            return
        }
        paperPlaneNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(paperPlaneNode)
    }
    
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
//ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if objectAppears {
            let image = CIImage(cvPixelBuffer: frame.capturedImage)
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
            let features = detector!.features(in: image)
            
            for feature in features as! [CIQRCodeFeature] {
                if !discoveredQRCodes.contains(feature.messageString!) {
                    discoveredQRCodes.append(feature.messageString!)
                    
                    let position = SCNVector3(frame.camera.transform.columns.3.x,
                                              frame.camera.transform.columns.3.y,
                                              frame.camera.transform.columns.3.z)
                    
                    self.configureLighting()
                    self.addPaperPlane(x: position.x, y: position.y, z: position.z)
                    self.objectAppears = false
                }
            }
        }
    }
    
    
}
