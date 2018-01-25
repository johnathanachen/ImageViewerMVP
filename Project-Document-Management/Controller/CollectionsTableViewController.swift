//
//  TableViewController.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/23/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit
import Zip

class CollectionsTableViewController: UITableViewController {
    
    // 1. Download initial json of image collections - DONE
    // 2. Decode into models - DONE
    // 3. Loop through each model and download the zip file -
    // 4. Unzip each zipped file -
    // 5. Update my images collection with unzippedUrl location
    // 6. Extract preview image
    
    
    var collections = [Collections]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    // MARK: - Networking
    Networking().fetch { (result) in
        guard let collections = result as? [Collections] else {return}
        
        DispatchQueue.main.async {
            self.collections = collections
            self.downloadAndUnzippfiles()
            self.tableView.reloadData()
            }
        }
    }
    
    
    private func downloadAndUnzippfiles() {
        //file maneger setting
        let fileManeger = FileManager.default
        
        //file url where saving unzipped file
        let fileUrl = try! fileManeger.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        //index of list of collections
        var index = 0
        
        //loop through list of collections
        for collection in self.collections {
            
            //downloads zipped file from an image url and save unzipped file to file url
            Downloader.load(from: collection.zippedImagesUrl, to: fileUrl, completion: {(result) in
                switch result {
                    
                //when result is filepath of unzipped file
                case let .done(filePath):
                    DispatchQueue.main.async {
                        
                        //gets an unzipped file name from a zipped image url
                        let filename = self.collections[index].zippedImagesUrl.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "+", with: " ")
                        
                        //saves an unzipped image url
                        self.collections[index].unzippedImagesUrl = filePath.appendingPathComponent(filename)
                        
                        //incriment number of index
                        index += 1
                        
                        //updates tableview cells
                        self.tableView.reloadData()
                    }
                    
                //when result is unzipping progress...
                case let .unzipping(progress):
                    
                    //update progress
                    self.collections[index].unzippingProgress = progress
                    
                case let .downloading(progress):
                    print(progress)
                    
                case let .error(error):
                    print(error)
                }
            })
            
        }
        
    }
    
    //load image data from a url
    private func loadImage(fileURL: URL?) -> UIImage? {
        do {
            guard let fileURL = fileURL else {return nil}
            
            //gets data from the url
            let imageData = try Data(contentsOf: fileURL)
            
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return self.collections.count

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionsCell", for: indexPath) as! CollectionsTableViewCell

        cell.collectionNameLabel.text = collections[index].collectionName
        //load image from a file url
        cell.thumbnailImage.image = loadImage(fileURL: collections[index].unzippedImagesUrl?.appendingPathComponent("_preview.png"))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        //selected row unzipped image url
        let unzippedImageUrl = collections[index].unzippedImagesUrl
        
        let imageCVC = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        
        //sends unzipped image url to imageCVC
        imageCVC.unzippedImageUrl = unzippedImageUrl
        
        navigationController?.pushViewController(imageCVC, animated: true)
        }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
