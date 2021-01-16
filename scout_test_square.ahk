#include config.ahk

;===================================================================
#SingleInstance force
MsgBox, ,, Script loaded. Activate WoW and press F12 to start testing!, 3
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include scout_lib.ahk
global wowid
WinGet, wowid, ID, World of Warcraft
SetKeyDelay, 0

CoordMode,Pixel,Screen ; Use screen coordinates
CoordMode,Mouse,Screen ;

global counter:=0

global discord_id:=WinExist("ahk_exe Discord.exe")
if !discord_id{
    MsgBox, Discord not open;
    ExitApp
}

F10::
MouseGetPos, square_x, square_y 
MsgBox, ,, Square 1 set!, 1
return

^F12:: 
    ExitApp
return

$F12::
if (enable := !enable)
  setTimer, Scout, -1
return

; Scout Loop
Scout:                                      
while enable
{
  ifWinExist, ahk_id %wowid% 
  {
	val := GetSquareValue(square_x, square_y)
	MsgBox,, Square Test Mode, UNIT_FOUND: %val% 	
    counter++
  }
}
return