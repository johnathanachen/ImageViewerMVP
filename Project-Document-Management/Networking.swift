//
//  Networking.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/24/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import Foundation

class Networking {
    let session = URLSession.shared
    let baseurl = "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json"
    
    func fetch(completion: @escaping (Decodable)->()) {
        let url = URL(string: baseurl)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                do  {
                    let collections = try JSONDecoder().decode([Collections].self, from: data)
                    completion(collections)
                } catch(let err) {
                    print("File decoding: \(err)")
                }
            } else {
                print("Session Filure: \(String(describing: error))")
            }
            }.resume()
    }
}
