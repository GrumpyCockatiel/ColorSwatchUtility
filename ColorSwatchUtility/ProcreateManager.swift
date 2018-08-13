//
//  JSONManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/3/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

// Procreate files are JSON files zipped with the .zip changed to .swatches
class ProcreateManager
{
    var colors:[ASEColor] = [];
    
    var groups:[ASEGroup] = [];
    
    var name:String = "Swatch";
    
    //
    init()
    {
        self.colors = [];
    }
    
    //
    init(colors:[ASEColor] )
    {
        self.colors = colors;
    }
    
    // writes a big JSON string of data
    func write() -> String
    {
        let root:NSMutableDictionary = NSMutableDictionary();
        root.setValue( self.name, forKey: "name");
        
        var data:[[String:String]] = [];
        
        for c in self.colors
        {
            data.append(c.color.toDictionary);
            //root.setValue( c.color.toDictionary, forKey: c.name );
        }
        
        for grp in groups
        {
            for cg in grp.colors
            {
                data.append(cg.color.toDictionary);
                //root.setValue( cg.color.toDictionary, forKey: cg.name );
            }
        }
        
        root.setValue(data, forKey: "swatches");
        
        do
        {
            // output the top object as an array
            let jsonData:Data = try JSONSerialization.data(withJSONObject: [root], options: []);
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
