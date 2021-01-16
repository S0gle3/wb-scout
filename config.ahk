; Feel free to edit any of these
;===========================================================================================================
global enable_log:=1                            ; if 1 writes to a log file, 0 to disable

global use_macros:=1                          ; if 1 uses macros bound to 1 and 5, instead of typing commands, 0 to disable

global is_rogue:=1 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=1 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting

global wait_loading_screen:=18000                ; time in ms to wait on character -> world loading screen

global use_libcopypaste:=0 ; if 1 uses libcoypaste, requires active wow client, if 0 uses WA square instead

global test_mode:=1 ; if 1 alerts party chat and test discord


;============================================================================================================
; Discord spam
; global discord_channel_spam:="#coordination world" ; "#coordination world" as to not confuse with warchief coordination
global discord_channel_spam:="#scout-bot-spom"
global msg_discord:="World Boss spawned: " 
global spam_delay:=1000 ; spam delay in ms 
global n_spam:=1    ; number of messages to send        

; Discord bot
; global discord_channel_bot:="#bot-pings"
global discord_channel_bot:="#scout-bot-channol"

global msg_discord_bot_cmd_azuregos:="!startevent azure" 
global msg_discord_bot_cmd_kazzak:="!startevent kazzak" 
global msg_discord_bot_cmd_dragons:="!startevent four" 

; Discord scout compromised
global msg_discord_scout_compromised:="Scout compromised? Status: "  

; Ingame
global msg_guild:="World Boss spawned: "

if (test_mode = 1){
	discord_channel_spam:="#scout-bot-spam"
	discord_channel_bot:="#scout-bot-channel"
}

;============================================================================================================
; Approved unitscan NPCs
; THESE NEED TO BE ADDED TO UNITSCAN /unitscan npc
global whitelist_NPC
    :=["AZUREGOS"
    ,"LORD KAZZAK"
    ,"EMERISS"
    ,"YSONDRE"
    ,"TAERAR"
    ,"LETHON"]

;============================================================================================================	
; Square coordinates if using WA square
; These are default coords. Use F10 to set new ones after loading the script
; Screenshot -> open paint -> CTRL+V easy way to get coordinates
global square_x:=1558
global square_y:=243
