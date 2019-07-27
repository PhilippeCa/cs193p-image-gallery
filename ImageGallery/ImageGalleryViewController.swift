//
//  ImageGalleryViewController.swift
//  ImageGallery
//
//  Created by Philippe on 29/06/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout {

    var gallery: ImageGallery?
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            imageCollectionView.dragDelegate = self
            imageCollectionView.dropDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - CollectionView data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.image = gallery?.images[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - CollectionView flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let aspectRatio = gallery?.images[indexPath.row].aspectRatio {
            let height = 128.0 / aspectRatio
            return CGSize(width: 128.0, height: height)
        } else {
            return CGSize(width: 128.0, height: 128.0)
        }
    }
    
    // MARK: - CollectionView drag delegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let galleryImage = gallery?.images[indexPath.item], let imageURL = galleryImage.url as NSURL? {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
            dragItem.localObject = galleryImage
            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: - CollectionView drop delegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return session.canLoadObjects(ofClass: URL.self) &&  (isSelf || session.canLoadObjects(ofClass: UIImage.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        // If drop was initiated from inside the app (aka reordering)
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        for item in coordinator.items {
            // Drag was initiated from this collectionView
            if let sourceIndexPath = item.sourceIndexPath {
                if let galleryImage = item.dragItem.localObject as? Image {
                    collectionView.performBatchUpdates({
                        gallery?.images.remove(at: sourceIndexPath.item)
                        gallery?.images.insert(galleryImage, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                // Drag was initiated from outside the app
                let placeholderContext = coordinator.drop(item.dragItem,
                                                          to: UICollectionViewDropPlaceholder(
                                                            insertionIndexPath: destinationIndexPath,
                                                            reuseIdentifier: "PlaceholderCell"))
                
                item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider?.imageURL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                let newImage = Image(url: url, aspectRatio: 1.0)
                                self.gallery?.images.insert(newImage, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: - UIDropInteraction delegate
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
//    }
//
//    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//
//    }
//
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        return UIDropProposal(operation: .copy)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
