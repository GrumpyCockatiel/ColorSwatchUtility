//
//  ASEBlock.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/1/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

// a group of colors
class ASEGroup : ASEBlock
{
    var name:String = "";
    
    var colors:[ASEColor] = [];
    
    init(_ name:String )
    {
        self.name = name;
    }
    
    // block length
    func length() -> Int
    {
        let len:Int = 2 + ( (self.name.count + 1) * 2 );
        
        // extra data length
        
        return len;
    }
}
