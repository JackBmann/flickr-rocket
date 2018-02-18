//
//  Photo.swift
//  FlickrRocket
//
//  Created by jbaumann on 2/17/18.
//  Copyright © 2018 jbaumann. All rights reserved.
//

import Foundation

struct Photo {
    
    let farm: Int
    let id: String
    let isFamily: Int
    let isFriend: Int
    let isPublic: Int
    let owner: String
    let secret: String
    let server: String
    let title: String
    let photoURL: URL
    
    
    // Create a Photo object
    init(farm: Int, id: String, isFamily: Int, isFriend: Int, isPublic: Int, owner: String, secret: String, server: String, title: String, photoURL: URL) {
        self.farm = farm
        self.id = id
        self.isFamily = isFamily
        self.isFriend = isFriend
        self.isPublic = isPublic
        self.owner = owner
        self.secret = secret
        self.server = server
        self.title = title
        self.photoURL = photoURL
    }
    
    // Create a Photo object from a dictionary using the above constructor
    init?(dictionary: [String: Any]) {
        /* Sample dictionary entry to be stored as a Photo:
             {
                 "farm": 9,
                 "id":"8658536632",
                 "isfamily": 0,
                 "isfriend": 0,
                 "ispublic": 1,
                 "owner":"35067687@N04",
                 "secret": "afab53f070",
                 "server":"8111",
                 "title": "Antares Rocket Preparation (201304160006HQ)"
             }
        */
        
        let farm = dictionary["farm"] as! Int
        let id = dictionary["id"] as! String
        let isFamily = dictionary["isFamily"] as? Int ?? 0
        let isFriend = dictionary["isFriend"] as? Int ?? 0
        let isPublic = dictionary["isPublic"] as? Int ?? 0
        let owner = dictionary["owner"] as! String
        let secret = dictionary["secret"] as! String
        let server = dictionary["server"] as! String
        let title = dictionary["title"] as! String
        
        // Generate the URL of the Photo
        let photoURLString = "https://farm" + String(farm) + ".static.flickr.com/" + server + "/" + id + "_" + secret + "_m.jpg"
        guard let photoURL = URL(string: photoURLString) else {
            print("Error creating photoURL for photo with id: ", id)
            return nil
        }
        
        // Contstruct a Photo object using the other init constructor
        self.init(farm: farm, id: id, isFamily: isFamily, isFriend: isFriend, isPublic: isPublic, owner: owner, secret: secret, server: server, title: title, photoURL: photoURL)
    }
}
