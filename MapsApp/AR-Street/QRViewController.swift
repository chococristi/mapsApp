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

    enum KinfOfError: Error {
        case noCameraAvailable
        case videoInputFail
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        //sceneView.showsStatistics = true
        let configuration = ARWorldTrackingConfiguration()
        sceneView.preferredFramesPerSecond = 30
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.session.delegate = self

//        do {
//          try self.scanQRCode()
//        } catch {
//
//            print("Failed to scan the QR/BarCode.")
//        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if !metadataObjects.isEmpty {
            let machineReadableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject

            if  machineReadableCode?.type == AVMetadataObject.ObjectType.qr {
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
            throw KinfOfError.noCameraAvailable
        }

        guard let avCaptureInput =  try? AVCaptureDeviceInput(device: avCaptureDevice) else {
                print("Failed  to init camera")
            throw KinfOfError.videoInputFail
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

    func addPaperPlane(xAxis: Float = 0, yAxis: Float = 0, zAxis: Float = -0.5) {
        guard let paperPlaneScene = SCNScene(named: "paperPlane.scn"),
            let paperPlaneNode = paperPlaneScene.rootNode.childNode(withName: "paperPlane",
                                                                    recursively: true)
            else {
                return
        }
        paperPlaneNode.position = SCNVector3(xAxis, yAxis, zAxis)
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

            guard let features = detector!.features(in: image) as? [CIQRCodeFeature] else {
                return
            }

            for feature in features {
                if !discoveredQRCodes.contains(feature.messageString!) {
                    discoveredQRCodes.append(feature.messageString!)

                    let position = SCNVector3(frame.camera.transform.columns.3.x,
                                              frame.camera.transform.columns.3.y,
                                              frame.camera.transform.columns.3.z)

                    self.configureLighting()
                    self.addPaperPlane(xAxis: position.x, yAxis: position.y, zAxis: position.z)
                    self.objectAppears = false
                }
            }
        }
    }

}
