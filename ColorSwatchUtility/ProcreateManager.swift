//
//  JSONManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/3/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

//
class ProcreateManager
{
    // creates a save file
    func write(colors:[ASEColor]) -> String
    {
        let root:NSMutableDictionary = NSMutableDictionary();
        
        for c in colors
        {
            root.setValue( c.color.toDictionary, forKey: c.name );
        }
        
        do
        {
            let jsonData:Data = try JSONSerialization.data(withJSONObject: root, options: []);
            let jsonStr:String = String(data: jsonData, encoding: String.Encoding.utf8)!;
            return jsonStr;
        }
        catch let error as NSError
        {
            print("Could not create JSON export: \(error.localizedDescription)");
        }
        
        return String.empty;
    }
}
