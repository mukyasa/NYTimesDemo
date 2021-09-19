//
//  ImageDownloaderEx.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloadImageFromURL(_ urlString: String) {
        image = nil

        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
            return
        }

        // otherwise fire off a new download
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in

            // download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }

            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage,
                                         forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            })

        }).resume()
    }
}
