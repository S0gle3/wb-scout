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
	if (use_libcopypaste = 1){
		ProcessIPCCmd()
	}
	else {
		ProcessSquare()
	}
	
	    ; Do a jump    
    if (Mod(counter,12) = 0 ){ ; 12
        ControlSend,, {Space}, ahk_id %wowid%    
        Sleep, 2000
    }
    
    ; Sleep
    Sleep, 1000
   
    
    counter++
    
    ; Logout and back in to avoid random disconnects
    if (Mod(counter,100) = 0 ){ ; 90
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
        Sleep, 5000
    }    
  }
  else
  {
	Sleep 1000
	;AlertDiscordCompromised("Client closed")
	Sleep 18000  
	ExitApp  
  }
}
return