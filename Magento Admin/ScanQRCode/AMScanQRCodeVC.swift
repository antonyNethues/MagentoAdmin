//
//  AMScanQRCodeVC.swift
//  AndrewMossAgencies
//
//  Created by Admin on 12/06/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation


protocol AMScanQRCodeVCDelegate : NSObjectProtocol {
    func setQRValue(val : String)
}


class AMScanQRCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    weak var delegateNew : AMScanQRCodeVCDelegate?
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var scanCodeText = String()
    var apiRun = Bool()
    var barcode = String()
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        apiRun = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Initial SetUp Methods
    
    func initialSetUp() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.frame = view.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            //view.bringSubview(toFront: messageLabel)
            //view.bringSubview(toFront: topView)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            // Move the message label and top bar to the front
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        getScreenSize()
    }
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    func getScreenSize(){
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        print("SCREEN RESOLUTION: "+screenWidth.description+" x "+screenHeight.description)
        videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
           // messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
               // messageLabel.text = metadataObj.stringValue
                scanCodeText = metadataObj.stringValue
               
                self.delegateNew?.setQRValue(val: scanCodeText)
                _ = self.navigationController?.popViewController(animated: true)
                
                self.webApiForCheckProduct()
                
            }
        }
    }
    
    //MARK: Button Action Methods
    
    @IBAction func crossButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true);
    }
    
    func webApiForCheckProduct(){
//        GMDCircleLoader.setOn(self.view, withTitle: "", animated: true)
//        let dicSet = NSMutableDictionary()
//        let defaults = UserDefaults.standard
//        dicSet.setObject("WK1lysGPJCInmneL", forKey : "apiKey" as NSCopying)
//        dicSet.setObject(defaults.string(forKey: "token")!, forKey : "token" as NSCopying)
//        let aString = scanCodeText
//        let newString = aString.replacingOccurrences(of: " ", with: "_")
//        dicSet.setObject(newString, forKey : "barcode" as NSCopying)
//        
//        print("Scanning dict is ",dicSet)
//        
//        ServiceHelper.callAPIWithParameters(dicSet, method:.get, apiName: "product/checkProduct") { (result, error) in
//            GMDCircleLoader.hide(from: self.view, animated: true)
//            if let dic = result as? Dictionary<String, AnyObject> {
//                print("the result dict is",dic)
//                if let status = dic["response"] as? NSInteger {
//                    if status == 200 {
//                        print("I have corret value")
//                        GMDCircleLoader.hide(from: self.view, animated: true)
//                        if (!self.apiRun)
//                        {
//                            KAppDelegate.selectionArray.add(self.scanCodeText)
//                           self.apiRun = true
//                        }
//                        KAppDelegate.isFromScan = true
//                        _ = self.navigationController?.popViewController(animated: true)
//                        
//                    }else{
//                        print("I have incorrect value")
//                        let alertController = UIAlertController(title: "Error", message: dic["message"] as! String?, preferredStyle: .alert)
//                        
//                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                            UIAlertAction in
//                        }
//                        alertController.addAction(okAction)
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
    }

    

}
