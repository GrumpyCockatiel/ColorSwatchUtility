//
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//
// For additional help, specifications and code see:
// https://github.com/ramonpoca/ColorTools
// http://www.cyotek.com/blog/writing-adobe-swatch-exchange-ase-files-using-csharp
// http://www.selapa.net/swatches/colors/fileformats.php#adobe_ase
// http://www.adobe.com/devnet-apps/photoshop/fileformatashtml/#50577411_pgfId-1055819

import Foundation

// create some colors for testing in code
// colors are stored as NSColor but you can easily use UIColor or your own generic color class depending on your needs
func someColors() -> ([ASEColor] , ASEGroup)
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

// read some data from a file
let io:IOManager = IOManager(name: "Colors", ext:"txt");
let colors:[String] = io.readTxt();

// parse the lines
let csv:CSVManager = CSVManager();
csv.read(lines: colors);

// create ASE manger and add everything
let ase:ASEManager = ASEManager();
let test:([ASEColor] , ASEGroup) = someColors();
ase.colors = test.0
//let grp:ASEGroup = ASEGroup("Group 1");
//grp.colors.append(contentsOf: csv.colors);
ase.groups.append(test.1);
// write to bytes
var bytes:Data = ase.write();

// write the file
io.filename = "ColorSwatchTest";
io.ext = "ase";
let result:Bool = io.write(bytes);

// read the file back in
bytes = io.read();
let c = bytes.count

if ( ase.read(block: bytes) )
{
    for c in ase.colors
    {
        print(c.name);
    }
    for g in ase.groups
    {
        print("Group \(g.name)");
        for cg in g.colors
        { print(cg.name) };
    }
}

// create a Procreate manager of the same colors
//let pro:ProcreateManager = ProcreateManager(colors: ase.colors);
//pro.colors.append(contentsOf: group.colors);

//let json:String = pro.write();

//let total:Int = ase.groups.reduce(0, {x,y in x+y.colors.count}) + ase.colors.count
//print("Wrote \(total) colors to an ASE file of size \(c).");

//print(json);


