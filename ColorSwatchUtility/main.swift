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


// read some data from a TXT file
let io:IOManager = IOManager(name: "Copic 358", ext:"txt");
let colors:[String] = io.readTxt();

// parse the lines
let csv:CSVManager = CSVManager();
if ( csv.read(lines: colors) > 0)
{ tester.printer(colors: csv.colors, groups: csv.groups); }

// create ASE manger and add everything
let ase:ASEManager = ASEManager();
ase.colors = csv.colors;
ase.groups = csv.groups;

// write to bytes
var bytes:Data = ase.write();

// write the ASE file
io.filename = "Copic 358";
io.ext = "ase";
let result:Bool = io.write(bytes);

// read the file back in
bytes = io.read();
let c = bytes.count

if ( ase.read(block: bytes) )
{ tester.printer(colors: ase.colors, groups: ase.groups); }

// write back the CSV data
csv.colors = ase.colors;
csv.groups = ase.groups;
let colors2:[String] = csv.write();
io.filename = "Copic Copy";
io.ext = "txt";
_ = io.write(colors2);

// create a Procreate manager of the same colors
let pro:ProcreateManager = ProcreateManager(colors: ase.colors);
//pro.colors.append(contentsOf: group.colors);

//let json:String = pro.write();

//let total:Int = ase.groups.reduce(0, {x,y in x+y.colors.count}) + ase.colors.count
//print("Wrote \(total) colors to an ASE file of size \(c).");

//print(json);

