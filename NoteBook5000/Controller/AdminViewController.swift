//
//  AdminViewController.swift
//  NoteBook5000
//
//  Created by Jonathan Nissen on 06/12/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
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
        let uploadRef = Storage.storage().reference(withPath: "Picture/\(randomID).jpg")
        guard let imageData =  ImageView.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
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
        }
         
        }
        
    }
    

