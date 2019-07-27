//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Philippe on 29/06/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectRatio: CGFloat {
        return size.width / size.height
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    var image: Image? {
        didSet {
            fetchImage()
        }
    }
    
    var loadedImage: UIImage? {
        didSet {
            if let view = imageView {
                view.image = loadedImage
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func fetchImage() {
        if let url = image?.url {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.image?.url {
                        self?.loadedImage = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
