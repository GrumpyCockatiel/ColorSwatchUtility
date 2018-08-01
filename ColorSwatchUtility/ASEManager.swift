//
//  ASEManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

class ASEManager
{
    var filename:String = "ColorSwatch";
    
    var colors:[ASEColor] = [];
    
    var groups:[ASEGroup] = [];
    
    //
    init(_ filename:String )
    {
        self.filename = filename;
    }
    
    //
    func write() -> Void
    {
        if ( Foundation.FileManager.default.fileExists(atPath: outputURL.path) )
        {
            try! Foundation.FileManager.default.removeItem(at: outputURL);
        }
        
        Foundation.FileManager.default.createFile(atPath: outputURL.path, contents: nil, attributes: nil);
        
        guard let aseFileHandle:FileHandle = try? FileHandle(forWritingTo: outputURL)
            else
        {
            return;
        }
        
        // write header and version
        self.writeHeader(aseFileHandle: aseFileHandle);
        
        // write block count
        self.writeBlockCount(aseFileHandle: aseFileHandle);
        
        // write global colors
        for color:ASEColor in self.colors
        {
            self.write(aseFileHandle: aseFileHandle, color:color);
        }
        
        // write groups
        for grp:ASEGroup in self.groups
        {
            self.write(aseFileHandle: aseFileHandle, group:grp);
        }

        aseFileHandle.closeFile();
    }
    
    private var outputURL:URL
    {
        let fileURL:URL = try! Foundation.FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
        
        return fileURL.appendingPathComponent(self.filename).appendingPathExtension("ase");
    }
    
    //
    private func writeHeader(aseFileHandle:FileHandle)
    {
        // init with ASEF header
        aseFileHandle.write(Data(bytes:[0x41, 0x53, 0x45, 0x46]));
        
        // version 1.0
        aseFileHandle.write(Data(bytes:[0x00, 0x01, 0x00, 0x00]));
    }
    
    // write number of blocks
    private func writeBlockCount(aseFileHandle:FileHandle)
    {
        // Blocks = begin group block + #colors + end block
        // blocks = # of groups * 2 + number of colors + number of group colors
        let cnt:Int = (self.groups.count * 2) + self.colors.count + self.groups.reduce(0, {x,y in x+y.colors.count});
        var count:UInt32 = CFSwapInt32HostToBig(UInt32(cnt));
        aseFileHandle.write(Data(bytes:&count, count:4));
    }
    
    // write a string with null termination
    private func writeString(aseFileHandle:FileHandle, str:String)
    {
        //var len:UnsafeMutablePointer<Int> = UnsafeMutablePointer<Int>.allocate(capacity: 1);
        //current.name.getBytes(&buffer, maxLength: 1024, usedLength: len, encoding: NSUTF16BigEndianStringEncoding, range: 0.0..<Double(current.name.count), remaining: []);
        
        let buf:[UInt16] = Array(str.utf16);
        let bigEndianArray:[UInt16] = buf.map { $0.bigEndian }
        
        // String len (16bit) and name (utf-16 bigendian) + 2 (null)
        var len:UInt16 = CFSwapInt16HostToBig(UInt16(str.count + 1));
        
        // write the length
        aseFileHandle.write(Data(bytes:&len, count:2));
        
        // the actual string
        aseFileHandle.write(Data(bytes:bigEndianArray, count:str.count*2));
        
        // zero pad
        aseFileHandle.write(Data(bytes:[0x00, 0x00], count:2));
    }
    
    //
    private func write(aseFileHandle:FileHandle, color:ASEColor) -> Void
    {
        // write block type enum - color
        var bt:UInt16 = CFSwapInt16HostToBig(BlockType.color.rawValue);
        aseFileHandle.write(Data(bytes:&bt, count:2));
        
        // write block length
        var blockLen:UInt32 = CFSwapInt32HostToBig(UInt32(color.length()));
        aseFileHandle.write(Data(bytes:&blockLen, count:4));
        
        // write name
        self.writeString(aseFileHandle: aseFileHandle, str: color.name)
        
        // write color space as 4 char string RGB or CMYK
        aseFileHandle.write( (ColorSpace.metadata[color.space]?.1)! );
        //aseFileHandle.write(Data(bytes:[0x52, 0x47, 0x42, 0x20]));
        
        // write values
        // STILL NEED TO FIX Based on space
        var rgba:[CGFloat] = color.color.getRGBA();
        aseFileHandle.write(float32SwappedToNetwork(Float32(rgba[0])));
        aseFileHandle.write(float32SwappedToNetwork(Float32(rgba[1])));
        aseFileHandle.write(float32SwappedToNetwork(Float32(rgba[2])));
        
        // write color type - global
        var ct:UInt16 = CFSwapInt16HostToBig(ColorType.global.rawValue);
        aseFileHandle.write(Data(bytes:&ct, count:2));
        
        // write extra data
    }
    
    //
    private func write(aseFileHandle:FileHandle, group:ASEGroup) -> Void
    {
        // write group start
        var bt:UInt16 = CFSwapInt16HostToBig(BlockType.start.rawValue);
        aseFileHandle.write(Data(bytes:&bt, count:2));
        
        // write block length
        var blockLen:UInt32 = CFSwapInt32HostToBig(UInt32(group.length()));
        aseFileHandle.write(Data(bytes:&blockLen, count:4));
        
        // write name
        self.writeString(aseFileHandle: aseFileHandle, str: group.name)
        
        // write all the colors
        // write global colors
        for color:ASEColor in group.colors
        {
            self.write(aseFileHandle: aseFileHandle, color:color);
        }
        
        // write group end
        bt = CFSwapInt16HostToBig(BlockType.end.rawValue);
        aseFileHandle.write(Data(bytes:&bt, count:2));
        aseFileHandle.write(Data(bytes:[0x00, 0x00, 0x00, 0x00], count:4));
    }
    
    // converts a float to Big Endian
    func float32SwappedToNetwork(_ f:Float32) -> Data
    {
        var sf32:CFSwappedFloat32 = CFConvertFloat32HostToSwapped(f);
        return Data(bytes:&(sf32.v), count:MemoryLayout<UInt32>.size);
    }
}
