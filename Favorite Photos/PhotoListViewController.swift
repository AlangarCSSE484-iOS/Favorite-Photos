//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by CSSE Department on 4/30/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func takePhoto(_ sender: Any) {
        
    }
    let photoCellIdentifier = "PhotoCell"
    var dataSnapshots = [DocumentSnapshot]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    

    

 

}
