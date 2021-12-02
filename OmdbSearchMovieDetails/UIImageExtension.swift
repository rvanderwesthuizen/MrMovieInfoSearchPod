//
//  UIImageExtension.swift
//  SearchMDFramework
//
//  Created by Ruan van der Westhuizen on 2021/12/02.
//

import UIKit

@objc extension UIImage {
    func loadImage(urlString: String) -> UIImage {
        var imageToReturn = UIImage(named: "noImageFound")!
        
        guard let url = URL(string: urlString) else { return UIImage(named: "noImageFound")!}
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageToReturn = image
                    }
                }
            }
        }
        
        return imageToReturn
    }
}
