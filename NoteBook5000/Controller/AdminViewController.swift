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

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    var imagePicker = UIImagePickerController()
    var fb = FirebaseRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.ImageView.image = image
    }
    
    @IBAction func takePhotoPressed(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        //self.ImageView.image =
    }
    
    @IBAction func uploadPhotoPressed(_ sender: UIButton) {
        
        if textField.text == "" || titleField.text == "" || ImageView.image == nil {
            fb.createAlert(title: "Error", message: "Skal have en title, tekst og et billed", caller: self)
            return
        }
        
        let randomID = UUID.init().uuidString
        let imagePath = "Picture/\(butikAdmin)/\(randomID).jpg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        
        guard let imageData =  ImageView.image?.jpegData(compressionQuality: 1) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no, something went wrong! \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            
            uploadRef.downloadURL { (url, error) in
                if let error = error{
                    print("Something went wrong! \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("Here is your download URL: \(url.absoluteString)")
                    self.textField.text = url.absoluteString
                }
            }
            self.uploadTekst(imagePath: imagePath)
        }
         
        }
    
    func uploadTekst(imagePath:String){
        
        if let messageBody = textField.text, let title = titleField.text {
            Firestore.firestore().collection(butikAdmin).addDocument(data: ["tekst": messageBody, "image": imagePath, "title": title ]) { (error) in
                if let error = error{
                    print("There was an error saving data to Firestore, \(error.localizedDescription)")
                } else {
                    print("Saved data")
                }
            }
        }
    }
    
    @IBAction func btnClicked() {

        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in

        })

        ImageView.image = image
    }
    
    
    
        
    }
