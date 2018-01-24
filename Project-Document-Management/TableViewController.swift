//
//  TableViewController.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/23/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit
import Zip

class TableViewController: UITableViewController {
    
    var incomingJSON = [myJSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
    }
    
    // 1. Download initial json of image collections -
    // 2. Decode into models -
    // 3. Loop through each model and download the zip file -
    // 4. Unzip each zipped file -
    // 5. Update my images collection with unzippedUrl location
    // 6. Extract preview image
    
    // MARK: - Networking

    func getJSON() {
        
        let urlString = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
        let config = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: config)
        let decoder = JSONDecoder()
        let url = URL(string: urlString)!
        var errorMessage = ""
        
        let task = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let incomingJSON = try decoder.decode([myJSON].self, from: data)
                    self.incomingJSON = incomingJSON
                    
                } catch let decodeError as NSError {
                    errorMessage += "Decoder error: \(decodeError.localizedDescription)"
                    return
                }
            }
        }
        task.resume()
    }
    
    func downloadZipFile(json: myJSON) {
        
    }
    
    // Download zip files
    func downloadZipFiles() {
        
        let urlString = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
        let config = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: config)
        
        for collection in incomingJSON {
            let url = URL(string: collection.zipped_images_url)!
            
            defaultSession.downloadTask(with: url, completionHandler: { (tempLocation, resp, error) in
                // 1.  Unzip to caches or documents directory
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
                
                if let documentDirectory: URL = urls.first {
                    let documentURL = documentDirectory.appendingPathComponent("txtFile.txt")
                    // data you want to write to file
                    URLResponse
                    try! resp.write(to: documentURL, options: .atomic)
                }
    
                
                // 2. Update your model with unzippedURL location
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.incomingJSON.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.textLabel?.text = self.incomingJSON[index].collection_name
        
        // Configure the cell...

        return cell
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
