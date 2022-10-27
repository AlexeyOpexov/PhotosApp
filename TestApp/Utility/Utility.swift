//
//  Utility.swift
//  TestApp
//
//  Created by OREKHOV ALEXEY on 23.10.2022.
//

import Foundation
import SDWebImageSwiftUI


func loadImageFromCash(url: String) -> UIImage {
    var cashImage = UIImage()

    SDWebImageManager.shared.loadImage(
        with: URL(string: url),
        options: [.highPriority, .progressiveLoad],
        progress: { (receivedSize, expectedSize, url) in
         //Progress tracking code
        },
        completed: { (image, data, error, cacheType, finished, url) in
            guard error == nil else { return }
            if let image = image {
                // do something with image
                cashImage = image
            }
        }
    )
    return cashImage
   
}
