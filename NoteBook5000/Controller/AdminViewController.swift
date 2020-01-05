//
//  AdminViewController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    var imagePicker = UIImagePickerController()
    var fb = FirebaseRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
@IBAction func takePhotoPressed(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        
        if textField.text == "" || titleField.text == "" || imageView.image == nil {
            fb.createAlert(title: "Error", message: "Skal have en title, tekst og et billed", caller: self)
            return
        }
        
        guard let messageBody = textField.text else {return}
        guard let title = titleField.text else {return}
        guard let image = imageView.image else {return}

        fb.uploadPhoto(messageBody: messageBody, title: title, image: image, caller: self)
          
        }

    
    @IBAction func pickPhoto() {

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageView.image = image
    }
    
    
    
        
    }
