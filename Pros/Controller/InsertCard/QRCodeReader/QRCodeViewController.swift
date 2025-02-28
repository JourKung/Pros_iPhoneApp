/*
* QRCodeReader.swift
*
* Copyright 2014-present Yannick Loriot.
* http://yannickloriot.com
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
*/

import UIKit
import AVFoundation

/// Convenient controller to display a view to scan/read 1D or 2D bar codes like the QRCodes. It is based on the `AVFoundation` framework from Apple. It aims to replace ZXing or ZBar for iOS 7 and over.
public final class QRCodeReaderViewController: UIViewController {
  private var cameraView = ReaderOverlayView()
  private var codeReader: QRCodeReader?
  private var cancelButton: UIButton = UIButton()
  private var switchCameraButton: SwitchCameraButton?
  
  weak var delegate: QRCodeReaderViewControllerDelegate?
  var completionBlock: ((String?) -> ())?
  
  deinit {
    codeReader?.stopScanning()
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  /// Initializes a view controller to read QRCodes from a displayed video preview and a cancel button to be go back.
  convenience public init(cancelButtonTitle: String) {
    self.init(cancelButtonTitle: cancelButtonTitle, metadataObjectTypes: [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode])//[AVMetadataObjectTypeQRCode])
  }
  
  /// Initializes a reader view controller with a list of metadata object types.
  convenience public init(metadataObjectTypes: [String]) {
    self.init(cancelButtonTitle: "Cancel", metadataObjectTypes:[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode])//[AVMetadataObjectTypeQRCode])
  }
  
  /// Initializes a view controller to read wanted metadata object types from a displayed video preview and a cancel button to be go back.
  convenience public init(cancelButtonTitle: String, metadataObjectTypes: [String]) {
    let reader = QRCodeReader(metadataObjectTypes: metadataObjectTypes)
    
    self.init(cancelButtonTitle: cancelButtonTitle, coderReader: reader)
  }
  
  /// Initializes a view controller using a cancel button title and a code reader.
  required public convenience init(cancelButtonTitle: String, coderReader reader: QRCodeReader) {
    self.init()
    
    codeReader           = reader
    view.backgroundColor = UIColor.blackColor()
    
    codeReader?.completionBlock = { [unowned self] (resultAsString) in
      if let _completionBlock = self.completionBlock {
        _completionBlock(resultAsString)
      }
      
      if let _delegate = self.delegate {
        if let _resultAsString = resultAsString {
          _delegate.reader(self, didScanResult: _resultAsString)
        }
      }
    }

    setupUIComponentsWithCancelButtonTitle(cancelButtonTitle)
    setupAutoLayoutConstraints()

    cameraView.layer.insertSublayer(codeReader!.previewLayer, atIndex: 0)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    codeReader?.startScanning()
  }
  
  override public func viewWillDisappear(animated: Bool) {
    codeReader?.stopScanning()
    
    super.viewWillDisappear(animated)
  }
  
  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    codeReader?.previewLayer.frame = view.bounds
  }
  
  // MARK: - Managing the Orientation
  
  func orientationDidChanged(notification: NSNotification) {
    cameraView.setNeedsDisplay()
    
    if codeReader?.previewLayer.connection != nil {
      let orientation = UIApplication.sharedApplication().statusBarOrientation
      
      codeReader?.previewLayer.connection.videoOrientation = QRCodeReader.videoOrientationFromInterfaceOrientation(orientation)
    }
  }
  
  // MARK: - Initializing the AV Components
  
  private func setupUIComponentsWithCancelButtonTitle(cancelButtonTitle: String) {
    cameraView.clipsToBounds = true
    cameraView.setTranslatesAutoresizingMaskIntoConstraints(false)
    view.addSubview(cameraView)
    
    if let _codeReader = codeReader {
      _codeReader.previewLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
      
      if _codeReader.previewLayer.connection.supportsVideoOrientation {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        _codeReader.previewLayer.connection.videoOrientation = QRCodeReader.videoOrientationFromInterfaceOrientation(orientation)
      }
      
      if _codeReader.hasFrontDevice() {
//        let newSwitchCameraButton = SwitchCameraButton()
//        newSwitchCameraButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        newSwitchCameraButton.addTarget(self, action: "switchCameraAction:", forControlEvents: .TouchUpInside)
//        view.addSubview(newSwitchCameraButton) // add switch camera button
        
//        switchCameraButton = newSwitchCameraButton
      }
    }
    
    cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
    
    cancelButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
    view.addSubview(cancelButton)
  }
  
  private func setupAutoLayoutConstraints() {
    let views: [NSObject: AnyObject] = ["cameraView": cameraView, "cancelButton": cancelButton]
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraView][cancelButton(40)]|", options: .allZeros, metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cameraView]|", options: .allZeros, metrics: nil, views: views))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cancelButton]-|", options: .allZeros, metrics: nil, views: views))
    
    if let _switchCameraButton = switchCameraButton {
      let switchViews: [NSObject: AnyObject] = ["switchCameraButton": _switchCameraButton]
      
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[switchCameraButton(50)]", options: .allZeros, metrics: nil, views: switchViews))
      view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[switchCameraButton(70)]|", options: .allZeros, metrics: nil, views: switchViews))
    }
  }
  
  // MARK: - Catching Button Events
  
  func cancelAction(button: UIButton) {
    codeReader?.stopScanning()
    
    if let _completionBlock = completionBlock {
      _completionBlock(nil)
    }
    
    delegate?.readerDidCancel(self)
  }
  
  func switchCameraAction(button: SwitchCameraButton) {
    codeReader?.switchDeviceInput()
  }
}

/// This protocol defines delegate methods for objects that implements the `QRCodeReaderDelegate`. The methods of the protocol allow the delegate to be notified when the reader did scan result and or when the user wants to stop to read some QRCodes.
protocol QRCodeReaderViewControllerDelegate: class {
  /// Tells the delegate that the reader did scan a code.
  func reader(reader: QRCodeReaderViewController, didScanResult result: String)
  
  /// Tells the delegate that the user wants to stop scanning codes.
  func readerDidCancel(reader: QRCodeReaderViewController)
}