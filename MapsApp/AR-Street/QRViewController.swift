//
//  QRViewController.swift
//  mapsApp
//
//  Created by Adrià González Fernández on 25/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

   
    @IBOutlet var videoPreview: UIView!
    var stringCode : String?
    
    enum error: Error {
        case NoCameraAvailable
        case VideoInputFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
          try self.scanQRCode()
        } catch{
            
            print("Failed to scan the QR/BarCode.")
        }
        // Do any additional setup after loading the view.
    }

    
   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            
            if  machineReadableCode?.type == AVMetadataObject.ObjectType.qr{
               self.stringCode = machineReadableCode?.stringValue
                // AÑADIR ACCION CUANDO HEMOS TENIDO EL VALOR DEL QR
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
