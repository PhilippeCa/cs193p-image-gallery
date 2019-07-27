//
//  ImageGalleryStore.swift
//  ImageGallery
//
//  Created by Philippe on 29/06/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import Foundation

class ImageGalleryStore {
    
    var store: [[ImageGallery]] {
        get {
            return [galleries, deletedGalleries]
        }
    }
    
    private var galleries: [ImageGallery]
    private var deletedGalleries: [ImageGallery]
    
    init() {
        galleries = [
            ImageGallery(name: "Test", images: [
                Image(url: URL(string: "https://images.unsplash.com/photo-1528920304568-7aa06b3dda8b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80")!, aspectRatio: 1.0),
                Image(url: URL(string: "http://www.scheerdetailing.com/wp-content/uploads/2015/07/thumb_IMG_3639_1024.jpg")!, aspectRatio: 1.0),
                
                ]),
            ImageGallery(name: "Test 2", images: [])]
        deletedGalleries = [ImageGallery(name: "Dikke brol", images: []), ImageGallery(name: "Dikke brol 2", images: [])]
    }
    
    func addGallery() {
        let galleryNames = (galleries + deletedGalleries).map { $0.name}
        galleries.append(ImageGallery(name: "Untitled".madeUnique(withRespectTo: galleryNames), images: []))
    }
    
    func removeGallery(_ gallery: ImageGallery) -> Bool? {
        if let galleryIndex = galleries.firstIndex(of: gallery) {
            deletedGalleries.append(galleries.remove(at: galleryIndex))
            return false
        } else if let removedGalleryIndex = deletedGalleries.firstIndex(of: gallery) {
            deletedGalleries.remove(at: removedGalleryIndex)
            return true
        }
        return nil
    }
    
    func recoverGallery(_ gallery: ImageGallery) {
        if let galleryIndex = deletedGalleries.firstIndex(of: gallery) {
            galleries.append(deletedGalleries.remove(at: galleryIndex))
        }
    }
    
}
