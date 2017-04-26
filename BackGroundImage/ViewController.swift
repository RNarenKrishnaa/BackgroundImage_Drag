//
//  ViewController.swift
//  BackGroundImage
//
//  Created by naren on 3/13/17.
//  Copyright © 2017 naren. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var ImgViewForBackGround: UIImageView!
    
    @IBOutlet weak var libraryImgViewForDrag: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    
    @IBOutlet weak var openPhotoLibrary: UIButton!
    let picker = UIImagePickerController()
    
    @IBOutlet weak var viewForDottedLine: UIView!
    @IBOutlet weak var lblForInstruction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        libraryImgViewForDrag.frame = CGRect(x: ImgViewForBackGround.frame.width/2-50, y: ImgViewForBackGround.frame.height/2-40, width: 150, height: 150)

        
        lblForInstruction.layer.borderWidth = 3
        lblForInstruction.layer.borderColor = UIColor.darkGray.cgColor
        lblForInstruction.backgroundColor = UIColor.white
        self.view.addSubview(lblForInstruction)
        
        let panGestureInLibraryViewImg = UIPanGestureRecognizer(target: self, action: #selector(panGestureForLibImg(gesture:)))
        let pinchGestureInLibraryViewImg = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureForLibImg(gesture:)))
        let rotateGestureInLibraryViewImg = UIRotationGestureRecognizer(target: self, action: #selector(rotateGestureForLibImg(gesture:)))
        
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addSubview(ImgViewForBackGround)
        ImgViewForBackGround.isUserInteractionEnabled = true
        libraryImgViewForDrag.isUserInteractionEnabled = true
        ImgViewForBackGround.addSubview(libraryImgViewForDrag)

        self.libraryImgViewForDrag.addGestureRecognizer(panGestureInLibraryViewImg)
        self.libraryImgViewForDrag.addGestureRecognizer(pinchGestureInLibraryViewImg)
        self.libraryImgViewForDrag.addGestureRecognizer(rotateGestureInLibraryViewImg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if picker.view.tag == 1{
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ImgViewForBackGround.contentMode = .scaleAspectFit
        ImgViewForBackGround.image = chosenImage
        self.view.addSubview(ImgViewForBackGround)
        lblForInstruction.isHidden = true
        dismiss(animated:true , completion: nil)
        }else{
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            libraryImgViewForDrag.contentMode = .scaleAspectFit
            libraryImgViewForDrag.image = chosenImage
            ImgViewForBackGround.addSubview(libraryImgViewForDrag)
            lblForInstruction.isHidden = true
            dismiss(animated:true , completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnOpenCameraClicked(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        picker.cameraCaptureMode = .photo
        lblForInstruction.isHidden = true
        picker.view.tag = 1
        present(picker,animated:true,completion: nil)
        }else{
            ifNoCamera()
        }
    }
    
    @IBAction func btnPhotoLibraryClicked(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.photoLibrary)!
        picker.modalPresentationStyle = .popover
        picker.view.tag = 2
        present(picker,animated: true,completion: nil)
        
    }

    func ifNoCamera () {
        let alert = UIAlertController(title: "Sorry", message: "Device has no Camera", preferredStyle:.alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(btnOk)
        present(alert,animated: true,completion: nil)
    }
    
    func panGestureForLibImg (gesture : UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: self.libraryImgViewForDrag)
        
        if let gestureView = gesture.view{
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        }
        
        gesture.setTranslation(CGPoint.zero, in: self.libraryImgViewForDrag)
    }
    
    func pinchGestureForLibImg (gesture : UIPinchGestureRecognizer){
        
        if let gestureView = gesture.view{
            gestureView.transform = CGAffineTransform.init(scaleX: gesture.scale, y: gesture.scale)
        }
        
        
    }
    
    func rotateGestureForLibImg (gesture : UIRotationGestureRecognizer){
        if let gestureView = gesture.view{
            gestureView.transform = CGAffineTransform.init(rotationAngle: gesture.rotation)
        }
    }
    
    
    
    
}

