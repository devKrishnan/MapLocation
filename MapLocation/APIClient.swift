//
//  APIClient.swift
//  MapLocation
//
//  Created by radhakrishnan S on 01/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation
//https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
let apiKey = ""
protocol APIResponse {
    func didSucced(results: Any) -> Void
    func didFail(message: String ) -> Void
}
typealias DataTaskResult = (NSData?, URLResponse?, NSError?) -> Void
protocol URLSessionProtocol {
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult)
        -> URLSessionDataTask
}
class APIClient{
    private var delegate : APIResponse!
    init(delegate : APIResponse) {
        self.delegate = delegate
    }
    //For supporting the unitteting of the API calls by mockinbg
    let session : URLSessionProtocol? = nil
   
    func geoCode(address : String) -> Void {
        let urlEncodedAddress = address.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let _encodedAddress = urlEncodedAddress {
            let resourceURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(_encodedAddress)&key=\(apiKey)"
            let session : URLSession = URLSession(configuration: URLSessionConfiguration.default)
            if let url = URL(string: resourceURL) {
                let task : URLSessionDataTask = session.dataTask(with: url, completionHandler: { (data:Data?, urlResponse: URLResponse?, error: Error?) in
                    if let results = JSONParser().locationResults(data: data){
                        self.delegate.didSucced(results: results)
                    }else{
                        self.delegate.didFail(message: "Oops! Operation failed. Please try again")
                    }
                })
                task.resume()
            }
            
        }

    }
    

}
