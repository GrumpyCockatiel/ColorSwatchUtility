//
//  UIColorExtensions.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/31/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation
import Cocoa

extension NSColor
{
    // init from a hex code value like A187FB, will remove any leading #
    convenience init(hexCode:String)
    {
        var s = hexCode.trim();
        
        // test for # and remove, test is in hex format
        if ( s.first == "#")
        {
            s.remove(at: s.startIndex);
        }
        
        if ( !s.isHexcode )
        { s = "000000"; }
        
        self.init( hex: UInt(s, radix:16)!);
    }
    
    // init from a singe RGB hex value stuffed in a UInt
    convenience init(hex:UInt)
    {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat(hex & 0xFF) / 255
        
        self.init(red:r, green: g, blue: b, alpha: 1.0);
    }
    
    // convert to RGBA values represented as [0,1.0]
    func getRGBA() -> [CGFloat]
    {
        return [self.redComponent, self.greenComponent, self.blueComponent, self.alphaComponent];
    }
    
    // convert to CMYK values represented as [0,1.0]
    func getCMYK() -> [CGFloat]
    {
        var k:CGFloat = 1.0;
        
        var c:CGFloat = 1.0 - self.redComponent;
        var m:CGFloat = 1.0 - self.greenComponent;
        var y:CGFloat = 1.0 - self.blueComponent;
        
        if ( c < k) { k = c; }
        if ( m < k) { k = m; }
        if ( y < k) { k = y; }
        
        if ( k >= 1.0 )
        { c = 0; m = 0; y=0;}
        else
        {
            c = ( c - k ) / ( 1.0 - k );
            m = ( m - k ) / ( 1.0 - k );
            y = ( y - k ) / ( 1.0 - k );
        }
        
        return [c,m,y,k];
    }
    
}
