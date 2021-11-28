//
//  ViewController+Flickr.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import Foundation
import CoreLocation
import UIKit


extension ViewController{
    
    func searchPhoto(at location:CLLocation){
        guard let url = getFlickrSearchURL(for: location) else {
            print("Error wrong search URL")
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){[weak self] data, response, error in
            guard let data = data else { return }
            if let flickrPhotos = try? JSONDecoder().decode(FlickrImageResult.self, from: data),
               let photoURL = flickrPhotos.photos?.photo?.first?.url{
                self?.downloadPhoto(at: photoURL)
            }
        }
        task.resume()
    }
    
    func downloadPhoto(at imageUrl:URL){
        URLSession.shared.downloadTask(with: imageUrl) {
            [weak self]  (tempUrl, response, error) in
            if let safeTempUrl = tempUrl {
                self?.saveFile(at: safeTempUrl)
            }
        }.resume()
    }
    
    private func getFlickrSearchURL(for location:CLLocation) -> URL?{
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                          URLQueryItem(name: "api_key", value: "c3c38861c3e034fe2649635e7a18826e"),
                          URLQueryItem(name: "lat", value: latitude),
                          URLQueryItem(name: "lon", value: longitude),
                          URLQueryItem(name: "per_page", value: "1"),
                          URLQueryItem(name: "format", value: "json"),
                          URLQueryItem(name: "nojsoncallback", value: "1")]
        var components = URLComponents(string: "https://www.flickr.com/services/rest/")!
        components.queryItems = queryItems
        return components.url
    }
    
    private func saveFile(at fileURL:URL){
        do {
            let fileName = String(NSDate().timeIntervalSince1970) + ".jpg"
            let savedURL = URL(fileURLWithPath: fileName, relativeTo: documentsURL)
            try FileManager.default.moveItem(at: fileURL, to: savedURL)
            snapshotData()
        } catch {
            print("Error: \(error)")
        }
    }
}
