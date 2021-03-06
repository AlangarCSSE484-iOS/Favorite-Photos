//
//  ImagePickerViewController.swift
//  Favorite Photos
//
//  Created by CSSE Department on 5/3/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //takePhot - func
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated:true)
    }
    
     func uploadImage(_ image: UIImage) {
        print("Super class does nothing....")
    }

}

//MARK: UIIMagePicker controller delegate methods
extension ImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            //TODO: Upload the data to storage, dislay AFTER the storage save is done
            //self.imageView.image = image //CHEAT. TODO: Delete this line
            
            uploadImage(image)
            
        }
        picker.dismiss(animated: true)
        
    }
    
}
