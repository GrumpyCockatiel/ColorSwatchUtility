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
    
    var groups:[ASEGroup] = [];
    
    var headers:[String] = ["name","color","group"];
    
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
    
    // read the lines and split on the , assume order name, color, group (optional) for now
    func write() -> [String]
    {
        var out:String = headers.joined(separator: ",");
        
        for c in self.colors
        {
            out.append(c.name + "," + c.color.getHexCode(true) + "\n" )
        }
        
        for g in self.groups
        {
            for c in g.colors
            {
                out.append(c.name + "," + c.color.getHexCode(true) + "," + g.name + "\n" )
            }
        }
        
        return [out];
    }
    
    // read the lines and split on the , assume order name, color, group (optional) for now
    func read(lines:[String], withHeaders:Bool = true)
    {
        for (idx,s) in lines.enumerated()
        {
            if ( withHeaders && idx == 0)
            { continue; }
            
            let parts = s.components(separatedBy: ",");
            if ( parts.count < 2)
            {continue; }
            
            // no group
            if ( parts.count < 3 || parts[2].isEmpty )
            {
                let color:ASEColor = ASEColor(hexcode: parts[1], name:parts[0]);
                self.colors.append(color);
            }
            else // group color
            {
                let exists:ASEGroup? = self.groups.first(where: { (grp) -> Bool in
                    grp.name == parts[2].trim();
                })
                
                if let e = exists
                {
                    e.colors.append( ASEColor(hexcode: parts[1], name:parts[0]) );
                }
                else // new group
                {
                    let group:ASEGroup = ASEGroup( parts[2].trim() );
                    group.colors.append( ASEColor(hexcode: parts[1], name:parts[0]) );
                    self.groups.append(group);
                }
            }

        }
    }
}
