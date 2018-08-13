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
    
    // inti with just colors
    init(colors:[ASEColor] )
    {
        self.colors = colors;
        self.groups = [];
    }
    
    // init with a list of color color groups
    init(groups:[ASEGroup] )
    {
        self.colors = [];
        self.groups = groups;
    }
    
    // init with individual colors and groups of colors
    init(colors:[ASEColor], groups:[ASEGroup] )
    {
        self.colors = colors;
        self.groups = groups;
    }
    
    // reads an ASE data block back in
    func read(block:Data) -> Bool
    {
        // reset everything
        self.colors = [];
        self.groups = [];
        
        let header:String? = String(bytes: [block[0],block[1],block[2],block[3]], encoding: .utf8);
        
        if ( header == nil || header != "ASEF")
        { return false; }
        
        if ( block[4] != 0x00 && block[5] != 0x01 && block[6] != 0x00 && block[7] != 0x00)
        { return false; }
        
        var _:UInt32 = self.bytesToUInt32(bytes: [block[8],block[9],block[10],block[11]]);

        // jump to the first block
        var i:Int = 12;
        
        // track a color group
        var group:ASEGroup? = nil;
        
        // while less that total bytes
        while ( i < block.count )
        {
            // read the block type
            let type:BlockType? = BlockType( rawValue: self.bytesToUInt16(bytes: [block[i],block[i+1]]) );
            i += 2;
            
            // read a color
            if ( type == .color)
            {
                // read block length
                let _ = self.bytesToUInt32(bytes: [block[i],block[i+1],block[i+2],block[i+3]]);
                i += 4;
                
                // read name
                let result:(String,Int) = self.readString(start: i, block: block);
                i += result.1;
                
                // read the color space
                let sd:Data = block.subdata( in: Range(i...i+4) );
                let space:ColorSpace = ColorSpace(bytes:sd);
                i += 4;
                
                if ( space == .RGB)
                {
                    // read the next 12 bytes
                    let red:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    let green:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    let blue:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    
                    let color:ASEColor = ASEColor(rgb: [red,green,blue], name: result.0);
                    color.space = space;
                    
                    if let grp = group
                    {
                        grp.colors.append(color);
                    }
                    else
                    { self.colors.append(color); }
                }
                else if ( space == .CMYK)
                {
                    // read the next 16 bytes
                    let cyan:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    let magenta:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    let yellow:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    let black:CGFloat = CGFloat( self.bytesToCGFloat( bytes: [block[i],block[i+1],block[i+2],block[i+3]] ) );
                    i += 4;
                    
                    let color:ASEColor = ASEColor(cmyk: [cyan,magenta,yellow,black], name: result.0);
                    color.space = space;
                    
                    if let grp = group
                    {
                        grp.colors.append(color);
                    }
                    else
                    { self.colors.append(color); }
                    
                }
                else if ( space == .Gray)
                {
                    i += 4;
                    print("Not supported");
                }
                
                // read color type
                i += 2;
            }
            else if ( type == .start)
            {
                // read block length
                let _ = self.bytesToUInt32(bytes: [block[i],block[i+1],block[i+2],block[i+3]]);
                i += 4;
                
                // read name
                let result:(String,Int) = self.readString(start: i, block: block);
                i += result.1;
                
                // start an ASE Group
                group = ASEGroup(result.0);
            }
            else if ( type == .end)
            {
                if ( block[i] != 0x00 && block[i+1] != 0x00 && block[i+2] != 0x00 && block[i+3] != 0x00)
                { print("End of Group not found."); }
                
                i += 4;
                
                // add current group to groups
                if let grp = group
                { self.groups.append(grp); }
                group = nil;
            }
            else
            { print("Unknown block type encountered."); }
        }
        
        return true;
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
    
    // read a string starting at the location specified
    private func readString(start:Int, block:Data) -> (String, Int)
    {
        let len:UInt16 = self.bytesToUInt16(bytes: [block[start],block[start+1]]);
        let sd:Data = block.subdata( in: Range(start+2...start+2+Int(len*2)-2) );
        let name:String? = String(bytes: sd, encoding: .utf16);
        
        if (name == nil)
        { return (String.empty, 2+Int(len*2) ); }
        
        return (name!, 2+Int(len*2) );
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
    
    //
    func bytesToUInt32(bytes:[UInt8]) -> UInt32
    {
        // get the block count
        let b:UInt32 = [bytes[0],bytes[1],bytes[2],bytes[3]].withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee;
        
        return CFSwapInt32BigToHost(b);
    }
    
    //
    func bytesToUInt16(bytes:[UInt8]) -> UInt16
    {
        let b:UInt16 = [bytes[0],bytes[1]].withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
            }.pointee;
        
        return CFSwapInt16BigToHost(b);
    }
    
    //
    func bytesToCGFloat(bytes:[UInt8]) -> Float32
    {
        let b:UInt32 = [bytes[0],bytes[1],bytes[2],bytes[3]].withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
            }.pointee;
        
        let arg:CFSwappedFloat32 = CFSwappedFloat32(v: b);
        
        return CFConvertFloat32SwappedToHost(arg);
    }
}
