ProcessIPCCmd(){
	WinActivate, ahk_id %wowid%
    cmd_str:=GetCmdStr()
	; Log found creature
	if (enable_log = 1){
		MyLog(cmd_str)
	}	
    if (cmd_str = "no_unit_found"){
        return
    }
	if (cmd_str = "/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Discovered Unit', unitscan_discovered_unit_name)" ){
		return
	}
	unit_found:= cmd_str
	; Check if NPC is allowed
	if not (hasValue(whitelist_NPC, unit_found)){
		return
	}
	; Found NPC on Whitelist
	; Alert
	Alert(unit_found)
	ExitApp
}

Alert(unit_found){	
	AlertIngame(unit_found)
	AlertDiscord(unit_found)
}

AlertIngame(unit_found){
	WinActivate, ahk_id %wowid%
	Sleep, 1000
	SendCmd("/guild " . msg_guild . unit_found)
	Sleep, 2000
}

SwitchChannel(discord_channel){
	Send, ^k
	SendDiscord(discord_channel)
	Sleep, 2000
	; Send escape twice in case already in correct channel
	Send, {Esc}	
	Send, {Esc}	
}

AlertDiscord(unit_found){
	WinRestore, ahk_id %discord_id%
	WinMaximize , ahk_id %discord_id%
	WinActivate, ahk_id %discord_id%
	Sleep, 3000	
	SwitchChannel(discord_channel_bot)
	Sleep, 1000
	SendDiscord(msg_discord_bot_cmd_kazzak)
	Sleep, 1000
	SwitchChannel(discord_channel_spam)
	Sleep, 1000
	Loop %n_spam%
	{
		SendDiscord(msg_discord . unit_found)
		Sleep, spam_delay
	}
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

GetCmdStr(){
    clipboard:="default_none"
	SendCmd("/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Discovered Unit', unitscan_discovered_unit_name)")
    Sleep 500
    Send, ^c
    Sleep 500
    Send, {Esc}
    cmd_str:=clipboard
    return  %cmd_str%
}

SendCmd(cmd_str){
    clipboard := cmd_str
    Send, {Enter}
    Sleep 200
    Send, ^v
    Sleep 200
    Send, {Enter}
 }  
 
MyLog(str){
    FileAppend, [%A_DD%-%A_MM%-%A_Hour%:%A_Min%:%A_Sec%]: %str%`n, scout.log
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