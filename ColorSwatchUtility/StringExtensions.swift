//
//  StringExtensions.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/31/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

extension String
{
    //  returns an empty string
    static var empty:String
    {
        get { return ""; }
    }
    
    // tests to see if a string is nothing but whitespace characters
    var isWhitespace:Bool
    {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    // tests if a string ONLY contains hex characters [0-9,A-F]
    var isHexcode:Bool
    {
        // if the string is empty it fails
        if ( self.isWhitespace )
        { return false; }
        
        // create a char set of invalid characters
        let invalidHex:CharacterSet = CharacterSet(charactersIn: "0123456789ABCDEFabcdef").inverted;
        
        // test the string
        let range = self.rangeOfCharacter(from: invalidHex, options: .caseInsensitive)
        
        // if not nil, the test failed
        if let _ = range
        { return false; }
        
        return true;
    }
    
    // trims all whitespace off a string including newlines
    func trim(_ newlines:Bool = true) -> String
    {
        if ( newlines )
        {
            return self.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines );
        }
        
        return self.trimmingCharacters( in: CharacterSet.whitespaces );
    }
    
    // Swift version of .NET IsNullOrWhitespace
    static func isNilOrWhitespace(_ str: String?) -> Bool
    {
        if let s = str
        {
            let trimmed = s.trimmingCharacters( in: CharacterSet.whitespacesAndNewlines );
            return trimmed.isEmpty;
        }
        
        return false;
    }

}
