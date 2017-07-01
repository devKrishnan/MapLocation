//
//  JSONParser.swift
//  MapLocation
//
//  Created by radhakrishnan S on 01/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation

public class JSONParser: NSObject {
    func locationResults(data:Data?)->([Any])?{
        do{
            if let _ = data {
                let dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                if let responseData = dictionary {
                    let results =  responseData["results"] as? [Any]
                    return results
                }
                return nil
            }
            else{
                return nil
            }
            
        }catch {
            //Handling Exception
            return nil
        }
        
    }
}
