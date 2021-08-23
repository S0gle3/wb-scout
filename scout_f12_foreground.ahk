#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include config.ahk
#include lib\msg_box.ahk
#include lib\scout.ahk
;===================================================================
SetKeyDelay, 0

global wowid
WinGet, wowid, ID, World of Warcraft


if !wowid{
    MsgBox, World of Warcraft not found!
    ExitApp
}

global discord_id:=WinExist("ahk_exe Discord.exe")
if !discord_id{
    MsgBox, Discord not found!
    ExitApp
}

MsgBox, 0, , % msg_box_txt

^F12:: 
    ExitApp
return

$F12::
if (enable := !enable)
  setTimer, Scout, -1
return

;===================================================================

global counter:=0

; Scout Loop
Scout:                                      
while enable
{
  ifWinExist, ahk_id %wowid% 
  {     	
    ; Load discovered_unit variable and decide to alert the boys
    ProcessIPCCmd()
    
    ; Sleep
    Sleep, 5000

    if (enable_duo_scout_mode=0){
      ; Avoid AFK by Moving Character
      if (Mod(counter,num_cycles_movement) = 0 ){ ; 12
        if (is_rogue=1){
          MoveCharacterOnGround()
        }
        else {
          MoveCharacterFlying()
        }
      }
    }

    counter++

    if (enable_duo_scout_mode=1){
      if (Mod(counter,num_cycles_before_duo_swap)=0){
        counter:=1 ; reset counter to 1
        SwapCharacter()
      }
    }
    
    ; Logout and back in to avoid random disconnects
    if (enable_duo_scout_mode=0 and Mod(counter,num_cycles_relog) = 0 ){ 
        Relog()
        Sleep 1500
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