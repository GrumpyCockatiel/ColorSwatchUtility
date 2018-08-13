//
//  Tester.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 8/12/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

class tester
{
    static func printer(colors:[ASEColor] , groups:[ASEGroup])
    {
        for c in colors
        {
            print(c.name);
        }
        
        for g in groups
        {
            print("Group \(g.name)");
            for cg in g.colors
            { print(cg.name) };
        }
    }
    
    // create some colors for testing in code
    // colors are stored as NSColor but you can easily use UIColor or your own generic color class depending on your needs
    static func someColors() -> ([ASEColor] , ASEGroup)
    {
        let black:ASEColor = ASEColor(hexcode:"#000000", name:"Black");
        let white:ASEColor = ASEColor(hexcode:"#FFFFFF", name:"White");
        let gray1:ASEColor = ASEColor(hexcode:"#484848", name:"Dark Gray");
        let gray2:ASEColor = ASEColor(hexcode:"#888888", name:"Mid Gray");
        let gray3:ASEColor = ASEColor(hexcode:"#C8C8C8", name:"Light Gray");
        let red:ASEColor = ASEColor(hexcode:"#FF0000", name:"Red");
        let green:ASEColor = ASEColor(hexcode:"#00FF00", name:"Green");
        let blue:ASEColor = ASEColor(hexcode:"#0000FF", name:"Blue");
        let cyan:ASEColor = ASEColor(hexcode:"#00FFFF", name:"Cyan");
        let magenta:ASEColor = ASEColor(hexcode:"#FF00FF", name:"Magenta");
        let yellow:ASEColor = ASEColor(hexcode:"#FFFF00", name:"Yellow");
        
        // create a group
        let group:ASEGroup = ASEGroup("Primaries");
        group.colors.append(red);
        group.colors.append(green);
        group.colors.append(blue);
        group.colors.append(yellow);
        group.colors.append(cyan);
        group.colors.append(magenta);
        
        return ([black,white, gray1, gray2, gray3], group);
    }
    
}
