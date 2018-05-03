//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by CSSE Department on 4/30/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: ImagePickerViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let photoCellIdentifier = "PhotoCell"
    var dataSnapshots = [DocumentSnapshot]()
    
    var photosStorageRef: StorageReference!
    var photosCollectionRef: CollectionReference!
    var photosListener: ListenerRegistration!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosStorageRef = Storage.storage().reference(withPath: "photos")
        photosCollectionRef = Firestore.firestore().collection("photos")

    }
    
    //MARK: LISTENER - TODO
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSnapshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier,
                                                      for: indexPath) as! PhotoViewCell
        //configure the cell
//        cell.captionLabel.text = "Best Photo ever"
//        cell.imageView.image = #imageLiteral(resourceName: "fab")
        
        cell.display(snapshot: dataSnapshots[indexPath.row])
        
        return cell
        
    }
    
    override func uploadImage(_ image: UIImage) {
        guard let data = ImageUtils.resize(image: image) else { return }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        let photoDocumentRef = photosCollectionRef.document()
        let photoStorageRef = photosStorageRef.child(photoDocumentRef.documentID)
        
        
        photoStorageRef.putData(
        data, metadata: uploadMetadata) {
            (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
                return
            }
        }
        
        photoStorageRef.downloadURL(completion: { (url, error) in
            if let error = error {
                print ("Error getting the download url. \(error.localizedDescription)")
            }
            if let url = url {
                print ("Saving the url \(url.absoluteString)")
                photoDocumentRef.setData(["url" : url.absoluteString,
                                          "caption": "Best photo ever",
                                          "created": Date()])
            }
        })
        
    }
    
    

    

 

}
