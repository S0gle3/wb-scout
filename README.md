# scout
This script will AFK scout for you and write in guild chat + discord once a unit on unitscan has beenf ound.

Streamable link https://streamable.com/qww8fe


Requires keyboard control, running discord and activated wow client. So must be run in the foreground! Best used while actually AFKing. 

## Requirements
https://www.autohotkey.com/

LibCopyPaste-1.0: https://www.curseforge.com/wow/addons/libcopypaste

Unzip the LibCopyPaste-1.0-v1.0.8-classic.zip and drag LibCopyPaste-* folder into your interface/addons then reload the game client to load the addon.

Modified unitscan. Contains 2 minor changes to `unitscan.lua` from the Praxis discord. 
in `unitscan.lua` on line 23 I added 

```
unitscan_discovered_unit_name = "no_unit_found"
```

in `unitscan.lua` on line 52 I added 

```
unitscan_discovered_unit_name = name
```



## Performance
Vulnerable to PVP in the open world. 

## Setup
A. Edit config file `config.ahk` to your liking. 

A. Character setup

## (optional) Macro setup
Set `use_macros:=1` in `config.ahk`!
Bind these macros to buttons 5 on your priest.

5. Logout
	```
		/p Relogging on purpose. Brb in 1min
		/raid Relogging on purpose. Brb in 1min
		/logout
	```

## Usage
Activate your WoW client with your scout character and press `F12` to enable the script.

You can press F12 to disable the script but it will finish the scout loop. 

Press CTRL+F12 to exit the script immediately

When a creature ID has been found it will spam discord and exit automaticly for now.

## Notes
This script will not alert you if you die.

use_macros is my preferred method as without macros your wow client must need be activated (have focus) most of the time.
