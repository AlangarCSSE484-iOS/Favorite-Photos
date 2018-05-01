//
//  ImageUtils.swift
//  Favorite Photos
//
//  Created by CSSE Department on 5/1/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Kingfisher 

class ImageUtils: NSObject {
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            
            imageView.kf.setImage(with: imgUrl)
            

        }
    }

}
