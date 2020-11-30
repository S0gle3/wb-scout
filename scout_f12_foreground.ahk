#include config.ahk

;===================================================================
#SingleInstance force
MsgBox, ,, Script loaded. Activate WoW and press F12 to start scouting!, 3
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include scout_lib.ahk
global wowid
WinGet, wowid, ID, World of Warcraft
SetKeyDelay, 0

global counter:=0 ; anti-afk

global discord_id:=WinExist("ahk_exe Discord.exe")
if !discord_id{
	MsgBox, Discord not open;
	ExitApp
}

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
	; Wait 5 seconds before checking
	Sleep, 5000
	
	; Load discovered_unit variable and decide to alert the boys or continue scouting
	ProcessIPCCmd()
	
	; Sleep
	Sleep, 1000
	
	; Do a jump	
	if (Mod(counter,6) = 0 ){
		ControlSend,, {Space}, ahk_id %wowid%	
		Sleep, 2000
	}
	
	counter++
	
	; Logout and back in to avoid random disconnects
	if (Mod(counter,60) = 0 ){
		SendCmd("/w Kekwmagew Logout: " . counter)
		;Logout()
		;Sleep, 32000
		;ControlSend,, {enter}, ahk_id %wowid% 
		;Sleep, 32000
	}
	; Wait 5 seconds 
	Sleep, 5000
  }
}
return