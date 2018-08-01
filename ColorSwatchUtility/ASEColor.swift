//
//  Color.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation
import Cocoa

//
protocol ASEBlock
{
    var name:String { get set };
    
    func length() -> Int;
}

//
class ASEColor : ASEBlock
{
    var name:String = "";
    
    var color:NSColor = NSColor.black;
    
    var space:ColorSpace = .RGB;
    
    init(_ color:String, name:String )
    {
        self.name = name;
        self.color = NSColor(hexCode:color);
    }
    
    init(_ color:String )
    {
        self.color = NSColor(hexCode:color);
    }
    
    // block length
    func length() -> Int
    {
        var len:Int = 2 + ( (self.name.count + 1) * 2 );
        
        // add 4 for color space and 2 for type
        len += 6;
        
        // space for the color values
        len += (ColorSpace.metadata[self.space]?.0)!;
        
        // extra data length
        
        return len;
    }
}
