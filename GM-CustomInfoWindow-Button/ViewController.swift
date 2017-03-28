//
//  ViewController.swift
//  GM-CustomInfoWindow-Button
//
//  Created by Marla Na on 22/03/2017.
//
//

import UIKit
import GoogleMaps


class ViewController: UIViewController, GMSMapViewDelegate ,UIGestureRecognizerDelegate, UITextViewDelegate{

    var blurEffectExtraLight : UIBlurEffect?
    var blurEffectLight : UIBlurEffect?
    var blurEffectDark : UIBlurEffect?
    
    var blurViewExtraLight : UIVisualEffectView?
    var blurViewLight : UIVisualEffectView?
    var blurViewDark : UIVisualEffectView?
    
    @IBOutlet weak var darkView: UIVisualEffectView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    var tappedMarker : GMSMarker?
    var customInfoWindow : CustomInfoWindow?
    @IBOutlet weak var testviewsecond: UITextView!
    
    
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var test: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 51.5287352, longitude: -0.3817818, zoom: 8)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 51.5287352, longitude: -0.3817818)
        marker.title = "My marker"
        marker.map = self.mapView
        
        let anotherMarker = GMSMarker()
        anotherMarker.position = CLLocationCoordinate2D(latitude: 52, longitude: -0.10)
        anotherMarker.title = "Another marker"
        anotherMarker.map = self.mapView

        self.tappedMarker = GMSMarker()
        self.customInfoWindow = CustomInfoWindow().loadView()
        textview.delegate = self
        testviewsecond.delegate = self
        
        self.mapView.delegate = self
        self.textview.layer.borderColor = UIColor.lightGray.cgColor
        self.textview.layer.borderWidth = 1
        self.textview.layer.cornerRadius = 8.0
        
        self.testviewsecond.layer.borderWidth = 1
        self.testviewsecond.layer.borderColor = UIColor.lightGray.cgColor
        self.testviewsecond.layer.cornerRadius = 8.0
        self.testviewsecond.isSecureTextEntry = true 
        
        textview.textColor = UIColor.lightGray
        testviewsecond.textColor = UIColor.lightGray
        test.isEnabled = true
        test.isUserInteractionEnabled = true
        //Set Extra Light Blur View
      /*  blurEffectExtraLight = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        blurViewExtraLight = UIVisualEffectView(effect: blurEffectExtraLight!)
        blurViewExtraLight!.frame = CGRect(x: 10, y: 70, width: 300, height: 100)
       
        view.addSubview(blurViewExtraLight!)
        
        
        //Set Light Blur View
        blurEffectLight = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurViewLight = UIVisualEffectView(effect: blurEffectLight!)
        blurViewLight!.frame = CGRect(x: 10, y: 220, width: 300, height: 100)
        
        view.addSubview(blurViewLight!)*/
        
        //Set Dark Blur View
        blurEffectDark = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurViewDark = UIVisualEffectView(effect: blurEffectDark!)
        blurViewDark!.frame = CGRect(x: 0, y: 0, width: 430, height: 800)
       // view.addSubview(blurViewDark!)
       view.addSubview(darkView)
        
        //Adding Pan gesture on all blur view
       // addPanGesture(blurViewToAdd: blurViewExtraLight!)
       // addPanGesture(blurViewToAdd: blurViewLight!)
        addPanGesture(blurViewToAdd: blurViewDark!)
        
        //Adding Information lable on all blur view
      //  addInfoLabel(sText: "iOS8 Extra Light Blur", blurViewToAdd: blurViewExtraLight!)
     //   addInfoLabel(sText: "iOS8 Light Blur", blurViewToAdd: blurViewLight!)
     //   addInfoLabel(sText: "iOS8 Dark Blur", blurViewToAdd: blurViewDark!)
    }

    
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("marker was tapped")
        tappedMarker = marker
    
        //get position of tapped marker
        let position = marker.position
        mapView.animate(toLocation: position)
        let point = mapView.projection.point(for: position)
        let newPoint = mapView.projection.coordinate(for: point)
        let camera = GMSCameraUpdate.setTarget(newPoint)
        mapView.animate(with: camera)
    
        let opaqueWhite = UIColor(white: 1, alpha: 0.85)
        customInfoWindow?.layer.backgroundColor = opaqueWhite.cgColor
        customInfoWindow?.layer.cornerRadius = 8
        customInfoWindow?.center = mapView.projection.point(for: position)
        customInfoWindow?.center.y -= 140
        customInfoWindow?.customWindowLabel.text = "This is my Custom Info Window"
        self.mapView.addSubview(customInfoWindow!)
    
        return false
    }

   func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        customInfoWindow?.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let position = tappedMarker?.position
        customInfoWindow?.center = mapView.projection.point(for: position!)
        customInfoWindow?.center.y -= 140
    }
    
    //Function : Add Pan gesture on all blur view
    func addPanGesture(blurViewToAdd:UIVisualEffectView) {
        // Adding Pan gesture on blurview
        var panGesture : UIPanGestureRecognizer?
        panGesture = UIPanGestureRecognizer(target: self, action: Selector(("handlePan:")))
        panGesture!.delegate = self
        blurViewToAdd.addGestureRecognizer(panGesture!)
    }
    //Function : Pan Gesture Handler
    func handlePan(recognizer:UIPanGestureRecognizer) {
        view.bringSubview(toFront: recognizer.view!)
        let translation = recognizer.translation(in: self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
                                          y:recognizer.view!.center.y + translation.y)
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    //Function : Add Information lable on all blur view
    func addInfoLabel(sText:String , blurViewToAdd:UIVisualEffectView) {
        let labelExtraLight = UILabel(frame: CGRect(x: 0  , y: 0, width: 300, height: 100))
        labelExtraLight.font = UIFont.systemFont(ofSize: 20)
        labelExtraLight.text = sText
        labelExtraLight.textColor = UIColor.red
        labelExtraLight.textAlignment = NSTextAlignment.center
        blurViewToAdd.contentView.addSubview(labelExtraLight)
    }

    @IBAction func dismiss(_ sender: UIButton) {
    
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .transitionCrossDissolve,animations: {
            self.textview.alpha = 0.0
            self.testviewsecond.alpha = 0.0
            self.image.alpha = 0.0
            self.darkView.alpha = 0.0
            
        }) { _ in
            self.darkView.removeFromSuperview()
            self.textview.removeFromSuperview()
            self.image.removeFromSuperview()
            self.testviewsecond.removeFromSuperview()
            
        }
       
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Username"
            textView.textColor = UIColor.lightGray
        }
    }
}

