//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Philippe on 29/06/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

struct ImageGallery: Equatable {
    static func == (lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var images: [Image]
}

struct Image {
    var url: URL
    var aspectRatio: Double
}
