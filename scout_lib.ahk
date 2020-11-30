ProcessIPCCmd(){
	WinActivate, ahk_id %wowid%
    cmd_str:=GetCmdStr()
	; Log found creature
	if (log_ids = 1){
		MyLog(cmd_str)
	}	
    if (cmd_str = "no_unit_found"){
        return
    }
	if (cmd_str = "/run local LibCopyPaste = LibStub('LibCopyPaste-1.0');LibCopyPaste:Copy('Discovered Unit', unitscan_discovered_unit_name)" ){
		return
	}
	; Something on unitscan found	
	;	alert the boys
	; Ingame message
	SendCmd("/w Kekwmagew Found Unit: " . cmd_str)
	Sleep, 2000
	SendCmd("/w Kekwmagew " . msg_guild . cmd_str)
	Sleep, 2000
	; Discord message
	WinRestore, ahk_id %discord_id%
	WinMaximize , ahk_id %discord_id%
	WinActivate, ahk_id %discord_id%
	Sleep, 1000
	SendDiscord(msg_discord . cmd_str)
	Sleep, 1000
    SendDiscord(msg_discord . cmd_str) 
	Sleep, 1000
    SendDiscord(msg_discord . cmd_str)
	Sleep, 240000
	ExitApp
	Sleep 100
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

SendDiscord(cmd_str){
	clipboard := cmd_str
    Send, ^v
    Sleep 200
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