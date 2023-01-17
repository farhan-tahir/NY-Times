//
//  Utility+Extensions.swift
//  NY Times
//
//  Created by Farhan Tahir on 1/16/23.
//

import UIKit

//MARK: - NSObject + Extension
extension NSObject {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: self.identifier, bundle: nil) }
}

//MARK: - UIImageView + Extension

var imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImage(from urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
            }
        }
    }
}
