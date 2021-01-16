ColorToSymbol(color){	
	if (color <= 40){
		return 0
	}
	else if (color <= 80){
		return 1
	}	
	else if (color <= 120){
		return 2
	}	
	else if (color <= 160){
		return 3
	}	
	else if (color <= 200){
		return 4
	}	
	else {
		return 5
	}		
}
; Capped at 120ish elements
global decode_table:={544: "AZUREGOS"
					, 545: "LORD KAZZAK"
					, 550: "EMERISS"
					, 551: "YSONDRE"
					, 552: "TAERAR"
					, 553: "LETHON"
					, 514: "DOOM LORD KAZZAK"
					, 515: "DOOMWALKER"
					, 451: "DEAD"
					, 452: "WORKING"
					, 453: "COMBAT"}

SymbolToDecode(S1, S2, S3){
	key:= S1 . S2 . S3
	val:= decode_table[(key)]
	if (val == "") {
		return "nil"
	}
	else {
		return val
	}
}
global repeated_fail_count:=0 

ReadSquareColor(x,y){
	PixelGetColor, color, x, y, RGB	
	; MsgBox The color at the current cursor position is %color%.
	; Seperate RGB into range (0-255)
	b := (color & 0xFF)
	g := ((color & 0xFF00) >> 8)
	r := ((color & 0xFF0000) >> 16)	
	return {"red": r, "green": g, "blue": b} 
}

GetSquareValue(x,y){
	colors := ReadSquareColor(x, y)	
	s_red := ColorToSymbol(colors.red)
	s_green := ColorToSymbol(colors.green)
	s_blue := ColorToSymbol(colors.blue)
	val := SymbolToDecode(s_red, s_green, s_blue)
	if (enable_log = 1){
		MyLog(Format("colors R: {} G: {} B: {} SR: {} SG: {} SB: {} key: {} val: {}", colors.red, colors.green, colors.blue, s_red, s_green, s_blue, s_red . s_green . s_blue, val))
	}		
	return val
}

ProcessSquare(){
	val := GetSquareValue(square_x, square_y)		
	; if nil -> square not set -> add fail count?
	if (enable_log = 1){
		MyLog(val)
	}	
	if (val = "nil"){
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
	
	if (val = "WORKING"){
		return
	}
    if (val = "COMBAT"){
		AlertDiscordCompromised("In Combat")
		if (test_mode = 1){
			return
		}
		Sleep 18000
		ExitApp	
        return
    }
	if (val = "DEAD"){
		AlertDiscordCompromised("Is Dead or Ghost")
		if (test_mode = 1){
			return
		}
		Sleep 18000
		ExitApp	
        return
    }
	unit_found:= val
	; Check if NPC is allowed
	if not (hasValue(whitelist_NPC, unit_found)){
		return
	}
	; Found NPC on Whitelist
	; Alert
	Alert(unit_found)
	;
	Sleep 5000
	if (test_mode = 1){
		WinActivate, ahk_id %wowid%
		Sleep 1000
		return
	}
	if (is_stay_logged_in=1){
		Sleep 60000
	}
	;WinKill, ahk_id %wowid%
	;ExitApp	
	
}

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
			if (test_mode = 1){
				return
			}
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
		AlertDiscordCompromised("In Combat")
		if (test_mode = 1){
			return
		}
		Sleep 18000
		ExitApp	
        return
    }
	if (cmd_str = "UnitIsDeadOrGhost"){
		AlertDiscordCompromised("Is Dead or Ghost")
		if (test_mode = 1){
			return
		}
		Sleep 18000
		ExitApp	
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
	;
	Sleep 5000
	if (is_stay_logged_in=1){
		Sleep 60000
	}
	WinKill, ahk_id %wowid%
	ExitApp	
}


Alert(unit_found){	
	AlertIngame(unit_found)
	AlertDiscord(unit_found)
}

AlertIngame(unit_found){
	WinActivate, ahk_id %wowid%
	Sleep, 1000
	if (test_mode = 1){
		SendCmd("/party " . msg_guild . unit_found)
	}
	else {
		; SendCmd("/guild " . msg_guild . unit_found)
		SendCmd("/w Wubbs " . msg_guild . unit_found)
	}
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
	if (unit_found = "AZUREGOS"){
		SendDiscord(msg_discord_bot_cmd_azuregos)
	}
	else if (unit_found = "LORD KAZZAK"){
		SendDiscord(msg_discord_bot_cmd_kazzak)
	}
	else if (unit_found = "EMERISS"){
		SendDiscord(msg_discord_bot_cmd_dragons)
	}
	else if (unit_found = "YSONDRE"){
		SendDiscord(msg_discord_bot_cmd_dragons)
	}
	else if (unit_found = "TAERAR"){
		SendDiscord(msg_discord_bot_cmd_dragons)
	}
	else if (unit_found = "LETHON"){
		SendDiscord(msg_discord_bot_cmd_dragons)
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
			ControlSend,, {Space}, ahk_id %wowid%
			Sleep, 2000
			
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