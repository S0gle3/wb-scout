# scout
This script will AFK scout for you and write in guild chat + discord once a unit on unitscan has been found.

Streamable link: https://streamable.com/qww8fe

Requires keyboard control, running discord and activated wow client. So must be run in the foreground! Best used while AFKing. 

## Setup
This video shows the demo version and gives you an idea of how it should look like! Streamable link: https://streamable.com/qww8fe

Step 1. Install autohotkey
https://www.autohotkey.com/

Step 2. Install LibCopyPaste Addon
LibCopyPaste-1.0: https://www.curseforge.com/wow/addons/libcopypaste

I provived the classic `LibCopyPaste-1.0-v1.0.8-classic.zip` version in the folder. 
Unzip the LibCopyPaste-1.0-v1.0.8-classic.zip and drag `/LibCopyPaste-1.0` folder into your interface/addons then **reload the game client** to load the addon.

Does it work?
Run this command ingame. If there's a prompt to accept custom scripts, click yes.
This should popup a window with some text. 
```
/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Install sucess', "LibCopyPaste installed successfully")
```

Step 3. Modify unitscan.lua 
I use a modified `unitscan.lua` file. 

For simplicity sake I included my entire `/unitscan` folder so you can copy-paste replace everything!

Does it work?
Run this command ingame. If it prints "nil" it is incorrect. If it prints "no_unit_found" it works correctly!
```
/script print(unitscan_discovered_unit_name)
```

## (optional) Config.ahk
A. Edit config file `config.ahk` to your liking. It works out of the box! 

Each line has a comment saying what it does.

These affect functionality so change these if needed
```
global is_rogue:=1 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=0 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting
```

## (optional) Macro setup
Set `use_macros:=1` in `config.ahk`!
Bind this macro to buttons 5 on your scout.

5. Logout
	```
		/p Relogging on purpose. Brb in 1min
		/raid Relogging on purpose. Brb in 1min
		/logout
	```

## Usage
Double-click `scout_f12_foreground.ahk` to load the script! It will show a confirm message if it's loaded.

Activate your WoW client with your scout character and press `F12` to start the script.

You can press F12 to disable the script but it will finish the scout loop. 

Press CTRL+F12 to exit the script immediately.

!Every 30mins or so this script will relog your character for 1min to avoid random disconnects.

## Notes
This script will not alert you if you die.


For details what I changed in unitscan: 2 minor changes to `unitscan.lua` from the Praxis discord. 
in `unitscan.lua` on line 23 I added 

```
unitscan_discovered_unit_name = "no_unit_found"
```

in `unitscan.lua` on line 52 I added 

```
unitscan_discovered_unit_name = name
```
