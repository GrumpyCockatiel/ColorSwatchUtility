//
//  UIColorExtensions.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/31/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation
import Cocoa

// extensions to NSColor
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
    
    //
    var toDictionary:[String:String]
    {
        var root:[String:String] = [String:String]();
        root["colorSpaceModel"] = String(self.colorSpace.colorSpaceModel.rawValue);
        
        if let hsb:NSColor = self.usingColorSpace(NSColorSpace.deviceRGB)
        {
            root["hue"] = hsb.hueComponent.description;
            root["saturation"] = hsb.saturationComponent.description;
            root["brightness"] = hsb.brightnessComponent.description;
            root["alpha"] = hsb.alphaComponent.description;
        }
        else
        {
            root["hue"] = "0.0";
            root["saturation"] = "0.0";
            root["brightness"] = "0.0";
            root["alpha"] = "1.0";
        }
        
        return root;
    }
    
    //
    static func fromDictionary(dict:[String:String]) -> NSColor
    {
        let hue:CGFloat = CGFloat( Double(dict["hue"]!)! );
        let sat:CGFloat = CGFloat( Double(dict["saturation"]!)! );
        let bright:CGFloat = CGFloat( Double(dict["brightness"]!)! );
        let alpha:CGFloat = CGFloat( Double(dict["alpha"]!)! );
        
        return NSColor(deviceHue: hue, saturation: sat, brightness: bright, alpha: alpha);
    }
    
}
