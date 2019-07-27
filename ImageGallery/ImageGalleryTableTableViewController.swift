//
//  ImageGalleryTableTableViewController.swift
//  ImageGallery
//
//  Created by Philippe on 29/06/2019.
//  Copyright © 2019 Philippe. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {

    var imageGalleryStore = ImageGalleryStore()
    
    @IBAction func newGallery(_ sender: UIBarButtonItem) {
        imageGalleryStore.addGallery()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return imageGalleryStore.store.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recently deleted" : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageGalleryStore.store[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageGalleryCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = imageGalleryStore.store[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let galleryToRemove = imageGalleryStore.store[indexPath.section][indexPath.row]
            if let result = imageGalleryStore.removeGallery(galleryToRemove) {
                if result {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    let newIndexPath = IndexPath(row: imageGalleryStore.store[1].firstIndex(of: galleryToRemove) ?? indexPath.row, section: indexPath.section + 1)
                    tableView.moveRow(at: indexPath, to: newIndexPath)
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // This could probably be done in a better way
        if indexPath.section == 0 {
            return nil
        } else {
            let recoverAction = UIContextualAction(style: .normal, title: "Undo delete") { _,_,_ in
                let galleryToRecover = self.imageGalleryStore.store[indexPath.section][indexPath.row]
                self.imageGalleryStore.recoverGallery(galleryToRecover)
                
                let newIndexPath = IndexPath(row: self.imageGalleryStore.store[0].firstIndex(of: galleryToRecover) ?? indexPath.row, section: indexPath.section - 1)
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
            
            return UISwipeActionsConfiguration(actions: [recoverAction])
        }
    }
    
    // Override to support rearranging the table view.
    //     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    //
    //     }
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Select gallery" else {
            return
        }

        if let imageGalleryVC = segue.destination as? ImageGalleryViewController {
            if let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) {
                let selectedGallery = imageGalleryStore.store[indexPath.section][indexPath.row]
                imageGalleryVC.gallery = selectedGallery
                imageGalleryVC.title = selectedGallery.name
            }
        }
    }
    
}
