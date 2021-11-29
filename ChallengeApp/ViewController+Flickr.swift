//
//  ViewController+Flickr.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import Foundation
import CoreLocation
import UIKit
import Combine

extension ViewController{
    static func searchPhotoWithURL(_ url:URL)-> AnyPublisher<URL,Error>{
        let request = URLRequest(url: url)
        return Self.session.dataTaskPublisher(for: request)
            .tryMap(Self.getURLFrom)
            .eraseToAnyPublisher()
    }
    
    static func downloadPhotoAtURL(_ imageUrl:URL) -> AnyPublisher<Bool,Error> {
        return Self.session.dataTaskPublisher(for: imageUrl)
            .tryMap(Self.saveFileWith)
            .eraseToAnyPublisher()
    }
    
    static func getURLFrom(data:Data, and response:URLResponse) throws -> URL {
        if let flickrPhotos = try? JSONDecoder().decode(FlickrImageResult.self, from: data),
           let photoURL = flickrPhotos.photos?.photo?.first?.url{
            return photoURL
        }
        throw FetchError.generic
    }
    
    static func getFlickrSearchURL(for location:CLLocation) throws-> URL{
        guard var components = URLComponents(string: "https://www.flickr.com/services/rest/") else {
            throw FetchError.generic
        }
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                          URLQueryItem(name: "api_key", value: Self.apiKey),
                          URLQueryItem(name: "lat", value: latitude),
                          URLQueryItem(name: "lon", value: longitude),
                          URLQueryItem(name: "per_page", value: "1"),
                          URLQueryItem(name: "format", value: "json"),
                          URLQueryItem(name: "nojsoncallback", value: "1")]
        components.queryItems = queryItems
        guard let url = components.url else {
            throw FetchError.generic
        }
        return url
    }
    
    private static func saveFileWith(data:Data,and response:URLResponse) throws -> Bool {
        let fileName = String(NSDate().timeIntervalSince1970) + ".jpg"
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentsURL)
        try data.write(to: fileURL)
        return true
    }
    
    private static func saveFile(at fileURL:URL){
        do {
            let fileName = String(NSDate().timeIntervalSince1970) + ".jpg"
            let savedURL = URL(fileURLWithPath: fileName, relativeTo: documentsURL)
            try FileManager.default.moveItem(at: fileURL, to: savedURL)
        } catch {
            print("Error: \(error)")
        }
    }
}
