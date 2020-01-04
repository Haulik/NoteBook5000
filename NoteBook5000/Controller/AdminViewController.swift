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
        let randomID = UUID.init().uuidString
        let imagePath = "Picture/\(butikAdmin)/\(randomID).jpg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        
        guard let imageData =  ImageView.image?.jpegData(compressionQuality: 0.75) else {return}
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
        
        if let messageBody = textField.text {
            Firestore.firestore().collection(butikAdmin).addDocument(data: ["tekst": messageBody, "image": imagePath ]) { (error) in
                if let error = error{
                    print("There was an error saving data to Firestore, \(error.localizedDescription)")
                } else {
                    print("Saved data")
                }
            }
        }
    }
    
    
    
        
    }
