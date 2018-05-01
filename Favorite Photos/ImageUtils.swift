//
//  ImageUtils.swift
//  Favorite Photos
//
//  Created by CSSE Department on 5/1/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class ImageUtils: NSObject {
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: imgUrl)
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                } catch {
                    print("Error downloading image: \(error.localizedDescription)") 
                }
            }
        }
    }

}
