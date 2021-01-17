# scout
This script will AFK scout for you and write in guild chat + discord once a unit on unitscan has been found.

Libcopypaste: This is how the demo version works with Hogger streamable link: https://streamable.com/qww8fe
Requires keyboard control, running discord and activated wow client. So must be run in the foreground! Best used while AFKing. 

Square: Move cursor to WA square, press F10 to record square position and F12 to start
Does NOT require keyboard control or focus. It does require the square to be visible
Square streamable https://streamable.com/9qcmoq


## TEST version vs MAIN version

The test version sends discord message to party chat and alerts the scout-bot-test-environment discord

https://discord.gg/DXr2tAMvMG

Do the setup once, then run demo version to try out the discord alerts and see how it works.

global test_mode:=1 is enabled by default. Set to 0 when scouting world bosses

## Setup
This video shows the demo version and gives you an idea of how it should look like! Streamable link: https://streamable.com/qww8fe

Step 1. Install autohotkey
https://www.autohotkey.com/

(libcopypaste) Step 2. Install LibCopyPaste Addon
LibCopyPaste-1.0: https://www.curseforge.com/wow/addons/libcopypaste

I provided the classic `LibCopyPaste-1.0-v1.0.8-classic.zip` version in the folder. 
Unzip the LibCopyPaste-1.0-v1.0.8-classic.zip and drag `/LibCopyPaste-1.0` folder into your interface/addons then **reload the game client** to load the addon.

Does it work?
Run this command ingame. If there's a prompt to accept custom scripts, click yes.
This should popup a window with some text. 
```
/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Install sucess', "LibCopyPaste installed successfully")
```

(square prefered method) Step 2. Install Weakaura https://wago.io/X63V8KRyn
or in WA_square.text

You must bind /logout to 5. See macro setup below

Step 3. Modify unitscan.lua 
I use a modified `unitscan.lua` file. 

For simplicity sake I included my entire `/unitscan` folder so you can copy-paste replace everything!

Does it work?
Run this command ingame. If it prints "nil" it is incorrect. If it prints "no_unit_found" it works correctly!
```
/script print(unitscan_discovered_unit_name)
```

## Config.ahk
A. Edit config file `config.ahk` to your liking. It works out of the box! 

Each line has a comment saying what it does.

These affect functionality so change these if needed
```
global is_rogue:=1 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=0 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting
```

Test mode is enabled by default. So try out the bot then change it to 0 before actually running it.
```
global test_mode:=1 
```
## Macro setup
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
