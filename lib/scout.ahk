global repeated_fail_count:=0 

ProcessIPCCmd(is_logging_out:=0){
	if (scout_in_background = 1){
	   return 	; skip IPC
	}
    command_str := "/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Discovered Unit', UnitAffectingCombat('player') and 'UnitAffectingCombat' or (UnitIsDeadOrGhost('player') and 'UnitIsDeadOrGhost' or unitscan_discovered_unit_name))"
    ; in combat?
    ;  	yes -> "UnitAffectingCombat"
    ; 	no -> am i ghost or dead?
    ;		yes -> "UnitIsDeadOrGhost"
    ;		no -> unitscan_discovered_unit_name

    cmd_str:=GetCmdStr(command_str)	
    ; Log cmd_str
    if (enable_log = 1){
        MyLog(cmd_str)
    }	
    if (cmd_str = command_str){
        ; disconnect check
        ; multiple returns of this = bot disconnected
        repeated_fail_count := repeated_fail_count + 1
        if (repeated_fail_count >= 6){
            AlertDiscordCompromised("Disconnected")
            Sleep 18000
            ExitApp	
        }	
        return
    }
    repeated_fail_count := 0
    
    if (cmd_str = "no_unit_found"){
        return
    }
    if (cmd_str = "UnitAffectingCombat"){
        AlertIngame("In Combat")
        Sleep 500
        if (is_rogue=1){
            AlertDiscordCompromised("In Combat")
            Sleep 18000
            ExitApp	
            return
        }
		return
    }
    if (cmd_str = "UnitIsDeadOrGhost"){
        AlertIngame("Has been Killed")
        Sleep 500
        AlertDiscordCompromised("Has been Killed")
        Sleep 18000
        ExitApp	
        return
    }

    unit_found:= cmd_str
    ; Check if NPC is allowed
    if not (hasValue(whitelist_NPC, unit_found)){
        if (enable_demo_mode = 0){ ; Only whitelist when not doing demo
            return
        }
    }
    ; Found NPC on Whitelist
    ;
    if (is_logging_out=1){ ; sent from SwapCharacter() after /logout
        WinActivate, ahk_id %wowid%
        Send, {Esc} ; stop logout
    }
    if (enable_duo_scout_mode=1){
        AlertDiscord(unit_found)
        Sleep 2000
        ; Disable duo scout mode and go scout other boss
        enable_duo_scout_mode:=0
        SwapCharacter(0) ; swap character without checking to avoid infinite loop
        return 1
    }
    else {
        AlertDiscord(unit_found)
        Sleep 2000
        if (is_stay_logged_in=1){
            WinActivate, ahk_id %wowid%
            AntiAFKLoop()
        }
        WinKill, ahk_id %wowid%
        ExitApp	
    }
}


AlertIngame(message){
    WinActivate, ahk_id %wowid%
    Sleep, 1000
    SendCmd(msg_ingame . message)
    Sleep, 2000
}

SwitchChannel(discord_channel){
    Send, ^k
    SendDiscord(discord_channel)
    Sleep, 2000
    ; Send escape twice in case already in correct channel
    Send, {Esc}	
    Sleep, 200
    Send, {Esc}	
}

AlertDiscord(unit_found){
    WinRestore, ahk_id %discord_id%
    WinMaximize , ahk_id %discord_id%
    WinActivate, ahk_id %discord_id%
    Sleep, 3000	

    SwitchChannel(discord_channel_bot)
    Sleep, 1000
    ; Which bot to start channel
    if (unit_found = "DOOMWALKER"){
        ; SendDiscord(msg_discord_bot_cmd_doomwalker)
		Sleep, 500
    }
    else if (unit_found = "DOOM LORD KAZZAK"){
        SendDiscord(msg_discord_bot_cmd_kazzak)
    }
    else {
        SendDiscord("Couldn't find bot command for unit: " . unit_found . "!")
    }	
    Sleep, 1000

    SwitchChannel(discord_channel_spam)
    Sleep, 1000
    Loop %n_spam%
    {
        SendDiscord(msg_discord . unit_found)
        Sleep, spam_delay
    }	
	
    if (unit_found = "DOOMWALKER"){
		SendDiscord("DOOMWALKER SPAWNED?")
		SendDiscordScreencap()		
    }
    else if (unit_found = "DOOM LORD KAZZAK"){
		SendDiscordConfirmHereEveryone(msg_discord_everyone_kazzak)
    }
    else {
        SendDiscordConfirmHereEveryone("@everyone")
    }	
    Sleep, 1000
}

AlertDiscordCompromised(status) {
    WinRestore, ahk_id %discord_id%
    WinMaximize , ahk_id %discord_id%
    WinActivate, ahk_id %discord_id%
    Sleep, 3000	

    SwitchChannel(discord_channel_spam)
    Sleep, 1000
    SendDiscord(msg_discord_scout_compromised . status)
}

SendDiscord(msg){
    clipboard := msg
    Send, ^v
    Sleep 1000
    Send, {Enter}
}

SendDiscordScreencap(){
    WinActivate, ahk_id %wowid%
	Sleep, 2000
	clipboard := "img"
	Send {Alt Down}{PrintScreen}{Alt Up}
    Sleep 1000
	WinRestore, ahk_id %discord_id%
    WinMaximize , ahk_id %discord_id%
    WinActivate, ahk_id %discord_id%
	Send, ^v
    Sleep 2000
    Send, {Enter}
}

SendDiscordConfirmHereEveryone(msg){
    clipboard := msg
    Send, ^v
    Sleep 5000
    Send, {Enter}
	Sleep 5000
    Send, {Enter}
}

GetCmdStr(cmd){
    WinActivate, ahk_id %wowid%
    clipboard:="default_none"
    SendCmd(cmd)
    Sleep 1000
    Send, ^c
    Sleep 1000
    Send, {Esc}
    cmd_str:=clipboard
    return  %cmd_str%
}


SendCmd(cmd_str){
    clipboard := cmd_str
    Send, {Enter}
    Sleep 700
    Send, ^v
    Sleep 700
    Send, {Enter}
 }  
 
MyLog(str){
    FileAppend, [%A_DD%-%A_MM%-%A_Hour%:%A_Min%:%A_Sec%]: %str%`n, scout.log
}

MoveCharacterFlying(){
    ControlSend,, {a down}, ahk_id %wowid%
    Sleep 350
    ControlSend,, {a up}, ahk_id %wowid%
    Sleep 350
    ControlSend,, {d down}, ahk_id %wowid%
    Sleep 350
    ControlSend,, {d up}, ahk_id %wowid%
    Sleep 350
}

MoveCharacterOnGround(){
    ControlSend,, {Space}, ahk_id %wowid%    
    Sleep, 2000
    ControlSend,, {Space}, ahk_id %wowid%    
    Sleep, 2000
}

Logout(){
    if (scout_in_background = 1){
        ControlSend,, 5, ahk_id %wowid%
    }
    else {
        WinActivate, ahk_id %wowid%
        SendCmd("/logout")
    }
}


SwapCharacter(check_while_logout:=1){
    Logout()
    if (check_while_logout=1){
        Sleep, 13600 ; 17000 - ProcessIPCCmd sum of sleeps (3400)
        found_something := ProcessIPCCmd(1)
    }
    else {
        Sleep, 17000
    }
    if (found_something){
        return ; discord alerted, logout cancelled
    }
    if (is_rogue=1){
        ; unstealth
        ControlSend,, 1, ahk_id %wowid% 
    }
    Sleep, wait_character_screen
    if (is_next_character_down = 1){
        ControlSend,, {down}, ahk_id %wowid% 
        is_next_character_down:=0
    }
    else {
        ControlSend,, {up}, ahk_id %wowid% 
        is_next_character_down:=1
    }
    Sleep, 1000
    ControlSend,, {enter}, ahk_id %wowid% 
    Sleep, %wait_loading_screen%        
    if (is_rogue=1){
        ; stealth
        ControlSend,, 1, ahk_id %wowid% 
    }
}

Relog(){
    Logout()
    Sleep, 13600 ; 17000 - ProcessIPCCmd sum of sleeps (3400)
    found_something := ProcessIPCCmd(true)
    if (found_something){
        ; should never reach this part if something found, either exitapp or anti-afk loop
        return ; discord alerted, logout cancelled
    }
    if (is_rogue=1){
        ; unstealth
        ControlSend,, 1, ahk_id %wowid% 
    }
    Sleep, wait_character_screen
    ControlSend,, {enter}, ahk_id %wowid% 
    Sleep, %wait_loading_screen%        
    if (is_rogue=1){
        ; stealth
        ControlSend,, 1, ahk_id %wowid% 
    }
}

AntiAFKLoop(){
    iterate:=0
    while 1 {
        ifWinExist, ahk_id %wowid% {  
        ; Avoid AFK by Moving Character
        if (Mod(counter,num_cycles_movement) = 0 ){ ; 12
            if (is_rogue=1){
                MoveCharacterOnGround()
            }
            else {
                MoveCharacterFlying()
            }
            
            WinActivate, ahk_id %wowid%
            Sleep, 69000 
            
            iterate++
            
            if (Mod(iterate,11) = 0 ){
                Relog()
            }
        }
    }
}

hasValue(haystack, needle) {
    if(!isObject(haystack))
        return false
    if(haystack.Length()==0)
        return false
    for k,v in haystack
        if(v==needle)
            return true
    return false
}