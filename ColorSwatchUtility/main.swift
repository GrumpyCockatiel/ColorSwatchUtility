//
//  main.swift
//  ColorSwatchUtility
//
//  Created by Tag Guillory on 7/30/18.
//  Copyright © 2018 TAG Digital Studios. All rights reserved.
//

import Foundation

let black:ASEColor = ASEColor("#000000", name:"Black");
let white:ASEColor = ASEColor("#FFFFFF", name:"White");
let red:ASEColor = ASEColor("#FF0000", name:"Red");
let green:ASEColor = ASEColor("#00FF00", name:"Green");
let blue:ASEColor = ASEColor("#0000FF", name:"Blue");

let group:ASEGroup = ASEGroup("Primaries");
group.colors.append(red);
group.colors.append(green);
group.colors.append(blue);

let io:ASEManager = ASEManager("Test");
io.colors = [black,white];
io.groups = [group];
io.write();

print("Wrote \(io.colors.count) colors.");
