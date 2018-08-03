//
//  ASEManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

// writes Adobe ASE format to a block of data
class ASEManager
{
    var colors:[ASEColor] = [];
    
    var groups:[ASEGroup] = [];
    
    //
    init()
    {
        self.colors = [];
        self.groups = [];
    }
    
    //
    init(colors:[ASEColor] )
    {
        self.colors = colors;
        self.groups = [];
    }
    
    //
    init(groups:[ASEGroup] )
    {
        self.colors = [];
        self.groups = groups;
    }
    
    //
    init(colors:[ASEColor], groups:[ASEGroup] )
    {
        self.colors = colors;
        self.groups = groups;
    }
    
    // main ASE file write function, wrtites to a Data block
    func write() -> Data
    {
        var ase:Data = Data();
        
        // write header and version
        self.writeHeader(block: &ase);
        
        // write block count
        self.writeBlockCount(block: &ase);
        
        // write global colors
        for color:ASEColor in self.colors
        {
            self.write(block: &ase, color:color);
        }
        
        // write groups
        for grp:ASEGroup in self.groups
        {
            self.write(block: &ase, group:grp);
        }

        return ase;
    }
    
    // write the ASE file header
    private func writeHeader(block:inout Data)
    {
        // init with ASEF header
        block.append(Data(bytes:[0x41, 0x53, 0x45, 0x46]) );
        
        // version 1.0
        block.append(Data(bytes:[0x00, 0x01, 0x00, 0x00]));
    }
    
    // write number of blocks
    private func writeBlockCount(block:inout Data)
    {
        // Blocks = begin group block + #colors + end block
        // blocks = # of groups * 2 + number of colors + number of group colors
        let cnt:Int = (self.groups.count * 2) + self.colors.count + self.groups.reduce(0, {x,y in x+y.colors.count});
        var count:UInt32 = CFSwapInt32HostToBig(UInt32(cnt));
        block.append(Data(bytes:&count, count:4));
    }
    
    // write a string with null termination
    private func writeString(block:inout Data, str:String)
    {
        //var len:UnsafeMutablePointer<Int> = UnsafeMutablePointer<Int>.allocate(capacity: 1);
        //current.name.getBytes(&buffer, maxLength: 1024, usedLength: len, encoding: NSUTF16BigEndianStringEncoding, range: 0.0..<Double(current.name.count), remaining: []);
        
        let buf:[UInt16] = Array(str.utf16);
        let bigEndianArray:[UInt16] = buf.map { $0.bigEndian }
        
        // String len (16bit) and name (utf-16 bigendian) + 2 (null)
        var len:UInt16 = CFSwapInt16HostToBig(UInt16(str.count + 1));
        
        // write the length
        block.append(Data(bytes:&len, count:2));
        
        // the actual string
        block.append(Data(bytes:bigEndianArray, count:str.count*2));
        
        // zero pad
        block.append(Data(bytes:[0x00, 0x00], count:2));
    }
    
    // write a color block
    private func write(block:inout Data, color:ASEColor) -> Void
    {
        // write block type enum - color
        var bt:UInt16 = CFSwapInt16HostToBig(BlockType.color.rawValue);
        block.append(Data(bytes:&bt, count:2));
        
        // write block length
        var blockLen:UInt32 = CFSwapInt32HostToBig(UInt32(color.length()));
        block.append(Data(bytes:&blockLen, count:4));
        
        // write name
        self.writeString(block: &block, str: color.name)
        
        // write color space as 4 char string RGB or CMYK
        block.append( (ColorSpace.metadata[color.space]?.1)! );
        //block(Data(bytes:[0x52, 0x47, 0x42, 0x20]));
        
        // write values
        // STILL NEED TO add gray and Lab
        var values:[CGFloat] = color.color.getRGBA();
        if ( color.space == .RGB)
        {
            block.append(float32SwappedToNetwork(Float32(values[0])));
            block.append(float32SwappedToNetwork(Float32(values[1])));
            block.append(float32SwappedToNetwork(Float32(values[2])));
        }
        else if ( color.space == .CMYK)
        {
            values = color.color.getCMYK();
            block.append(float32SwappedToNetwork(Float32(values[0])));
            block.append(float32SwappedToNetwork(Float32(values[1])));
            block.append(float32SwappedToNetwork(Float32(values[2])));
            block.append(float32SwappedToNetwork(Float32(values[3])));
        }
        
        // write color type - global
        var ct:UInt16 = CFSwapInt16HostToBig(ColorType.global.rawValue);
        block.append(Data(bytes:&ct, count:2));
        
        // write extra data
    }
    
    // write the color group
    private func write(block:inout Data, group:ASEGroup) -> Void
    {
        // write group start
        var bt:UInt16 = CFSwapInt16HostToBig(BlockType.start.rawValue);
        block.append(Data(bytes:&bt, count:2));
        
        // write block length
        var blockLen:UInt32 = CFSwapInt32HostToBig(UInt32(group.length()));
        block.append(Data(bytes:&blockLen, count:4));
        
        // write name
        self.writeString(block: &block, str: group.name)
        
        // write all the colors
        // write global colors
        for color:ASEColor in group.colors
        {
            self.write(block: &block, color:color);
        }
        
        // write group end
        bt = CFSwapInt16HostToBig(BlockType.end.rawValue);
        block.append(Data(bytes:&bt, count:2));
        block.append(Data(bytes:[0x00, 0x00, 0x00, 0x00], count:4));
    }
    
    // converts a float to Big Endian
    func float32SwappedToNetwork(_ f:Float32) -> Data
    {
        var sf32:CFSwappedFloat32 = CFConvertFloat32HostToSwapped(f);
        return Data(bytes:&(sf32.v), count:MemoryLayout<UInt32>.size);
    }
}
