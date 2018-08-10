//
//  Types.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/1/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

// enuermates the different color space models
enum ColorSpace : String
{
    init()
    {
        self = .Unknown;
    }
    
    // init from the 4 bytes
    init(bytes:Data)
    {
        switch bytes[0]
        {
            case 0x52:
                self = .RGB;
            case 0x43:
                self = .CMYK;
            case 0x47:
                self = .Gray;
            case 0x4c:
                    self = .Lab;
            default:
                self = .Unknown;
        }
    }
    
    case Unknown = "";
    case XYZ = "xyz";
    case RGB = "rgb";
    case Hex = "hex";
    case CMYK = "cmyk";
    case Lab = "lab";
    case Gray = "gray";
    
    static let metadata:[ColorSpace:(Int,Data)] = {
        var temp = [ColorSpace:(Int,Data)]();
        temp[.RGB] = (12, Data(bytes:[0x52, 0x47, 0x42, 0x20]));
        temp[.CMYK] = (16, Data(bytes:[0x43, 0x4D, 0x59, 0x4B]));
        temp[.Gray] = (4, Data(bytes:[0x47, 0x72, 0x61, 0x79]));
        temp[.Lab] = (12, Data(bytes:[0x4C, 0x41, 0x42, 0x20]));
        return temp;
    }()
}

// the ASE block type identifier - 2 bytes
enum BlockType : UInt16
{
    case color = 0x0001;
    case start = 0xc001;
    case end = 0xc002;
}

// the color type identifier - 2 bytes
enum ColorType : UInt16
{
    case global = 0x0000;
    case spot = 0x0001;
    case normal = 0x0002
}
