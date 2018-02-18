//
//  ImageDownloadService.swift
//  FlickrRocket
//
//  Created by jbaumann on 2/17/18.
//  Copyright © 2018 jbaumann. All rights reserved.
//

import UIKit

class ImageDownloadService {
    
    // Create a shared instance of the ImageDownloadService object
    static var shared = ImageDownloadService()
    
    // Create an image cache that maps URLs to UIImages, so that if an image from a given URL has already been downloaded it does not need to be re-downloaded.
    var cachedImages: [URL: UIImage] = [:]
    
    // Downloads the image at the given URL or retireves it from cachedImages and returns it
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        // If the image has already been cached, retrieve it
        if let image = cachedImages[url] {
            completion(image)
            return
        }
        
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            guard let imageData = data else {
                print("Error in retrieving image data")
                return
            }
            
            let image = UIImage(data: imageData)
            
            // Cache it
            self.cachedImages[url] = image
            
            completion(image)
        }
        task.resume()
    }
}
