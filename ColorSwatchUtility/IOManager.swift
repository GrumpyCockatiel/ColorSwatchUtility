//
//  FileManager.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/3/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

// handles IO to a file
class IOManager
{
    // file name to use
    var filename:String = "MyFile";
    
    // extensions to use
    var ext:String = "ase";
    
    //
    init(name:String, ext:String)
    {
        self.filename = name;
        self.ext = ext;
    }

    // resolve the default path to the desktop - put in another file
    var outputURL:URL
    {
        let desktopURL:URL = try! Foundation.FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true);
        
        return desktopURL.appendingPathComponent(self.filename).appendingPathExtension(self.ext);
    }
    
    // read a file to a block of data
    func read() -> Data
    {
        if ( !Foundation.FileManager.default.fileExists(atPath: self.outputURL.path) )
        {
            return Data();
        }
        
        guard let handle:FileHandle = try? FileHandle(forReadingFrom: self.outputURL)
        else
        {
            return Data();
        }
        
        // write header and version
        return handle.readDataToEndOfFile();
    }
    
    // writes a block of data as a file
    func write(_ contents:Data) -> Bool
    {
        if ( Foundation.FileManager.default.fileExists(atPath: self.outputURL.path) )
        {
            try! Foundation.FileManager.default.removeItem(at: self.outputURL);
        }
        
        Foundation.FileManager.default.createFile(atPath: self.outputURL.path, contents: nil, attributes: nil);
        
        guard let handle:FileHandle = try? FileHandle(forWritingTo: self.outputURL)
        else
        {
            return false;
        }
        
        // write header and version
        handle.write(contents);
        
        handle.closeFile();
        
        return true;
    }
    
}