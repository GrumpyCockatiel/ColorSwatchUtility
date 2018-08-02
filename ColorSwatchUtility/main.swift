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
let black:ASEColor = ASEColor("#000000", name:"Black");
let white:ASEColor = ASEColor("#FFFFFF", name:"White");
let gray:ASEColor = ASEColor("#999999", name:"Gray");
let red:ASEColor = ASEColor("#FF0000", name:"Red");
let green:ASEColor = ASEColor("#00FF00", name:"Green");
let blue:ASEColor = ASEColor("#0000FF", name:"Blue");

// create a group
let group:ASEGroup = ASEGroup("Primaries");
group.colors.append(red);
group.colors.append(green);
group.colors.append(blue);

// create the manger and add everything
let io:ASEManager = ASEManager("Test");
io.colors = [black,white, gray];
io.groups = [group];

// write the file
io.write();

let total:Int = io.groups.reduce(0, {x,y in x+y.colors.count}) + io.colors.count
print("Wrote \(total) colors.");
