//
//  TableViewController.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/23/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    var incomingJSON = [myJSON]()
    
    let urlString = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
        
    }
    
    // MARK: - Networking
    
    func getData(url: String) {
        Alamofire.request(urlString).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success")
            }
            else {
                print("error")
            }
        }
    }
    
    func getJSON() {
        let config = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: config)
        
        let decoder = JSONDecoder()
        let urlString = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
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
                    print(incomingJSON[1].zipped_images_url)
                } catch let decodeError as NSError {
                    errorMessage += "Decoder error: \(decodeError.localizedDescription)"
                    return
                }
            }
        }
        task.resume()
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
