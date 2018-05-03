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
    
    let itemsPerRow = 2
    let sectionInsets = UIEdgeInsetsMake(30.0, 10.0, 30.0, 10.0)
    
    var photosStorageRef: StorageReference!
    var photosCollectionRef: CollectionReference!
    var photosListener: ListenerRegistration!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosStorageRef = Storage.storage().reference(withPath: "photos")
        photosCollectionRef = Firestore.firestore().collection("photos")

    }
    
    //MARK: LISTENER
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photosListener = photosCollectionRef
            .order(by: "created", descending: true)
            .limit(to: 12)
            .addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                print ("Error getting firestore photos. error: \(error.localizedDescription)")
            }
            if let snapshot = querySnapshot {
                print ("Got some photos :)")
                
                self.dataSnapshots = snapshot.documents
                self.collectionView.reloadData()
                
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photosListener.remove()
    }
    
    func getCaption(_ documentRef: DocumentReference) {
        let ac = UIAlertController(title: "Set image caption", message: "", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Image caption"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            let captionTextField = ac.textFields![0]
            documentRef.updateData(["caption" : captionTextField.text!])
        }
        ac.addAction(okAction)
        present(ac, animated: true)
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
        
        DispatchQueue.main.async {
            self.getCaption(photoDocumentRef)
        }
        
        
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

extension PhotoListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}






