# Color Swatch Utility

## Disclaimer
I'm in the middle of adding code that will ZIP the Procreate JSON format back into an archive so it doesn't full work with Procreate yet

## Description

Some simple Swift 4 classes to convert a collection of colors to/from an Adobe ASE Swatch file, Procreate file or plain CSV file. 

You can use this to read an Adobe ASE swatch file in and get a collection of the colors, and then write it back out to somethinglike Procreate JSON format or just CSV

## Example

```
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
pro.colors = ase.colors;
pro.groups = ase.groups;

let json:String = pro.write();
print(json);
```

