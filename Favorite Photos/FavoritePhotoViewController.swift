//
//  FavoritePhotoViewController.swift
//  Favorite Photos
//
//  Created by CSSE Department on 4/30/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

class FavoritePhotoViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var storageRef: StorageReference!
    var photoDocRef: DocumentReference!
    var photoListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference(withPath: "favorite")
        photoDocRef = Firestore.firestore().collection("favorite").document("photo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListener = photoDocRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print ("Error getting firestore docuemtn \(error.localizedDescription)")
            }
            if let url = snapshot?.get("url") as? String {
                print("Loading image from url...")
                // TODO: Make a helper class that everyone can use
                ImageUtils.load(imageView: self.imageView, from: url)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if photoListener != nil {
            photoListener.remove()
        }
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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadImage(_ data: Data?) {
        guard let data = data else { return }
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        progressView.isHidden = false
        progressView.progress = 0
        
        let uploadTask = storageRef.putData(
        data, metadata: uploadMetadata) {
            (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
            }
        }
        uploadTask.observe(StorageTaskStatus.progress) { (snapshot) in
            guard let progress = snapshot.progress else { return }
            self.progressView.progress = Float(progress.fractionCompleted)
        }
        uploadTask.observe(StorageTaskStatus.success) { (snapshot) in
            print("Your upload is finished")
            self.progressView.isHidden = true
            
            self.storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print ("Error getting the download url. \(error.localizedDescription)")
                }
                if let url = url {
                    print ("Saving the url \(url.absoluteString)")
                    self.photoDocRef.setData(["url" : url.absoluteString])
                }
            })
        }
    }
}



//MARK: UIIMagePicker controller delegate methods
extension FavoritePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage {
            //TODO: Upload the data to storage, dislay AFTER the storage save is done
            //self.imageView.image = image //CHEAT. TODO: Delete this line
            
            uploadImage(UIImageJPEGRepresentation(image, 0.5))
        
        }
        picker.dismiss(animated: true)
        
    }
    
}
