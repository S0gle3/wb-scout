global repeated_fail_count:=0 

ProcessIPCCmd(){
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
    AlertDiscord(unit_found)
    ;
    Sleep 5000
    if (is_stay_logged_in=1){
        WinActivate, ahk_id %wowid%
        AntiAFKLoop()
    }
    WinKill, ahk_id %wowid%
    ExitApp	
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
        SendDiscord(msg_discord_bot_cmd_doomwalker)
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
		SendDiscordConfirmHereEveryone(msg_discord_everyone_doomwalker)
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

Logout(){
    if (use_macros = 1){
        ControlSend,, 5, ahk_id %wowid%
    }
    else {
        WinActivate, ahk_id %wowid%
        SendCmd("/logout")
    }
}

SendDiscord(msg){
    clipboard := msg
    Send, ^v
    Sleep 1000
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

AntiAFKLoop(){
    iterate:=0
    while 1 {
        ifWinExist, ahk_id %wowid%
        {  
            if (is_rogue=1){
                ControlSend,, {Space}, ahk_id %wowid%    
                Sleep, 2000
            }
            else {
                ControlSend,, {a down}, ahk_id %wowid%
                Sleep 500
                ControlSend,, {a up}, ahk_id %wowid%
                Sleep 500
                ControlSend,, {d down}, ahk_id %wowid%
                Sleep 500
                ControlSend,, {d up}, ahk_id %wowid%
                Sleep 500
            }
            
            WinActivate, ahk_id %wowid%
            Sleep, 69000 
            
            iterate++
            
            if (Mod(iterate,11) = 0 ){
                Logout()
                Sleep, 17000
                if (is_rogue=1){
                    ; unstealth
                    ControlSend,, 1, ahk_id %wowid% 
                }
                Sleep, 15000
                ControlSend,, {enter}, ahk_id %wowid% 
                Sleep, %wait_loading_screen%        
                if (is_rogue=1){
                    ; stealth
                    ControlSend,, 1, ahk_id %wowid% 
                }
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