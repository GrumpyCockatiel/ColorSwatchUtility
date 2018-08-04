//
//  CSVManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/4/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

//
class CSVManager
{
    var colors:[ASEColor] = [];
    
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
    
    // read the lines and split on the , assume name is first and color second for now
    func read(lines:[String])
    {
        for s in lines
        {
            let parts = s.components(separatedBy: ",");
            if ( parts.count < 2)
            {continue; }
            
            let color:ASEColor = ASEColor(hexcode: parts[1], name:parts[0]);
            self.colors.append(color);
        }
    }
}
