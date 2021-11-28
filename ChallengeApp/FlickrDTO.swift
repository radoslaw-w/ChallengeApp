//
//  FlickrDTO.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 28/11/2021.
//

import Foundation

struct FlickrImageResult : Codable {
    var photos : FlickrPhoto? = nil
}

struct FlickrPhoto : Codable {
    var photo : [FlickrURLs]? = nil
}

struct FlickrURLs: Codable {
    let id : String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    
    var url:URL  {
        let fileName = "\(id)_\(secret)_b.jpg"
        var photoURL = URL(string: "https://live.staticflickr.com/")!
        photoURL.appendPathComponent(server)
        photoURL.appendPathComponent(fileName)
        return photoURL
    }
}
