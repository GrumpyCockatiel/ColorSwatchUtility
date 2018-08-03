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

// create some colors using hex codes
// colors are stored as NSColor but you can easily use UIColor or your own generic color class depending on your needs
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

// create the manger and add everything
let ase:ASEManager = ASEManager();
ase.colors = [black,white, gray1, gray2, gray3];
ase.groups = [group];
var bytes:Data = ase.write();

// write the file
let io:IOManager = IOManager(name: "ColorSwatchUtil", ext:"ase");
let result:Bool = io.write(bytes);

// read the file back in
bytes = io.read();
let c = bytes.count

let total:Int = ase.groups.reduce(0, {x,y in x+y.colors.count}) + ase.colors.count
print("Wrote \(total) colors to an ASE file of size \(c).");
