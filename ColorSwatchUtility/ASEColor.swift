//
//  Color.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation
import Cocoa

// generic block protocol
protocol ASEBlock
{
    var name:String { get set };
    
    func length() -> Int;
}

// A single color
class ASEColor : ASEBlock
{
    var name:String = "";
    
    var color:NSColor = NSColor.black;
    
    var space:ColorSpace = .RGB;
    
    // init with just hex code
    init()
    {
        self.color = NSColor.black;
    }
    
    // init with hex code and name
    init(hexcode hex:String, name:String )
    {
        self.name = name;
        
        self.color = NSColor(hexCode:hex);
    }
    
    // init with just hex code
    init(hexcode hex:String )
    {
        self.color = NSColor(hexCode:hex)
    }
    
    // init with an array of RGB values (12 bytes)
    init(rgb:[CGFloat], name:String )
    {
        self.name = name;
        
        self.color = NSColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1);
    }
    
    // init with an array of CMYK values (16 bytes)
    init(cmyk:[CGFloat], name:String )
    {
        self.name = name;
        
        let rgb:[CGFloat] = NSColor.CMYKToRGB(cmyk);
        self.color = NSColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1);
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
