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
    
    // what folder
    var dir:FileManager.SearchPathDirectory = .desktopDirectory;
    
    //
    init(name:String, ext:String)
    {
        self.filename = name;
        self.ext = ext;
    }

    // resolve the default path to the desktop - put in another file
    var currentPath:URL
    {
        get {
            let desktopURL:URL = try! Foundation.FileManager.default.url(for: self.dir, in: .userDomainMask, appropriateFor: nil, create: true);
            
            return desktopURL.appendingPathComponent(self.filename).appendingPathExtension(self.ext);
        }
    }
    
    //
    func readTxt() -> [String]
    {
        var lines:[String] = [String]();
        
        do
        {
            let contents:String = try String(contentsOfFile: self.currentPath.path, encoding: String.Encoding.utf8);
            lines = contents.components(separatedBy: "\n");
        }
        catch let error as NSError
        {
            print(error);
        }
        
        return lines;
    }
    
    // read a file to a block of data
    func read() -> Data
    {
        if ( !Foundation.FileManager.default.fileExists(atPath: self.currentPath.path) )
        {
            return Data();
        }
        
        guard let handle:FileHandle = try? FileHandle(forReadingFrom: self.currentPath)
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
        if ( Foundation.FileManager.default.fileExists(atPath: self.currentPath.path) )
        {
            try! Foundation.FileManager.default.removeItem(at: self.currentPath);
        }
        
        Foundation.FileManager.default.createFile(atPath: self.currentPath.path, contents: nil, attributes: nil);
        
        guard let handle:FileHandle = try? FileHandle(forWritingTo: self.currentPath)
        else
        {
            return false;
        }
        
        // write header and version
        handle.write(contents);
        
        handle.closeFile();
        
        return true;
    }
    
    // writes a collection of Strings as lines in a file
    func write(_ lines:[String]) -> Bool
    {
        var written:String = "";
        
        for s in lines
        {
            written.append(s);
        }
        
        do
        {
            try written.write(to: self.currentPath, atomically: true, encoding: String.Encoding.utf8);
        }
        catch let error as NSError
        {
            print("Failed writing to URL: \(self.currentPath), Error: " + error.localizedDescription);
            return false;
        }
        
        return true;
    }
    
}
