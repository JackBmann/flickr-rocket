//
//  NetworkingService.swift
//  FlickrRocket
//
//  Created by jbaumann on 2/17/18.
//  Copyright © 2018 jbaumann. All rights reserved.
//

import Foundation

class NetworkingService {
    
    // Create a shared instance of the NetworkingService object
    static var shared = NetworkingService()
    
    // Fetches the data for the given URL, unwraps its dictionaries, converts the dictionaries to Photo objects, and returns a list of all the Photos
    func fetchPhotoSearchResults(url: URL, completion: @escaping ([Photo]) -> ()) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let searchResults = data else {
                print("Error in retrieving search results")
                return
            }
            
            // A list of each result in the searchResults json stored as dictionaries to be mapped to Photo later.
            var photosAsDictionaries: [[String: Any]] = []
            
            // Creating and unwrapping the searchResults json
            let json = try! JSONSerialization.jsonObject(with: searchResults, options: [])
            if let dictionary = json as? [String: Any] {
                // The information about the photos is located in the "photo" key of the resulting dictionary, so unwrap it.
                if let nestedDictionary = dictionary["photos"] as? [String: Any] {
                    photosAsDictionaries = nestedDictionary["photo"] as! [[String: Any]]!
                }
            }
            
            // Map each dictionary to a Photo using the Photo constructor and return it
            let photosAsPhotos = photosAsDictionaries.map { Photo(dictionary: $0)! }
            
            completion(photosAsPhotos)
        }
        task.resume()
    }
}
