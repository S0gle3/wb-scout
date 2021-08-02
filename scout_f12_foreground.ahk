#include config.ahk

;===================================================================
#SingleInstance force
MsgBox, ,, Script loaded. Activate WoW and press F12 to start scouting!, 3
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
    ; Load discovered_unit variable and decide to alert the boys or continue scouting
    ProcessIPCCmd()
    
    ; Sleep
    Sleep, 5000
    
    ; Do a jump    
    if (Mod(counter,num_cycles_movement) = 0 ){ ; 12
      if (is_rogue=1){
        ControlSend,, {Space}, ahk_id %wowid%    
        Sleep, 2000
      }
      else {
        ControlSend,, {a down}, ahk_id %wowid%
        Sleep 350
        ControlSend,, {a up}, ahk_id %wowid%
        Sleep 350
        ControlSend,, {d down}, ahk_id %wowid%
        Sleep 350
        ControlSend,, {d up}, ahk_id %wowid%
        Sleep 350
      }
    }
    
    ; Sleep
	if (test_mode = 1){
		Sleep, 100
	}
	else {
		Sleep, 1000
	}    
    counter++
    
    ; Logout and back in to avoid random disconnects
    if (Mod(counter,num_cycles_relog) = 0 ){ 
        Logout()
        Sleep, 17000
        if (is_rogue=1){
            ; unstealth
            ControlSend,, 1, ahk_id %wowid% 
        }
        Sleep, 15000
        ControlSend,, {enter}, ahk_id %wowid% 
		
		if (use_libcopypaste = 1){
			Sleep, %wait_loading_screen%     
		}
		else {
			; Scan for WA
			Sleep, %wait_loading_screen%    
		}
        if (is_rogue=1){
            ; stealth
            ControlSend,, 1, ahk_id %wowid% 
    }
    Sleep, 1500
    }
    else {
        Sleep, sleep_cycle_duration
    }    
  }
  else
  {
  Sleep 1000
  AlertDiscordCompromised("Client closed")
  Sleep 18000  
  ExitApp  
  }
}
return