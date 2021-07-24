; Feel free to edit any of these
;===========================================================================================================
global enable_log:=1                            ; if 1 writes to a log file, 0 to disable

global use_macros:=0                           ; if 1 uses macros bound to 1 and 5, instead of typing commands, 0 to disable

global is_rogue:=0 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=1 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting

global wait_loading_screen:=18000                ; time in ms to wait on character -> world loading screen

;============================================================================================================
; Discord spam
global discord_channel_spam:="world-boss-spam" ; "#coordination world" as to not confuse with warchief coordination
;global discord_channel_spam:="#coordination world" ; "#coordination world" as to not confuse with warchief coordination
global msg_discord:="World Boss spawned: " 
global spam_delay:=1000 ; spam delay in ms 
global n_spam:=4    ; number of messages to send        

; Discord bot
global discord_channel_bot:="#world-boss-bot-command"
;global discord_channel_bot:="#bot-pings"
global msg_discord_bot_cmd_azuregos:="!startevent azure" 
global msg_discord_bot_cmd_kazzak:="!startevent kazzak" 
global msg_discord_bot_cmd_dragons:="!startevent four" 

; Discord scout compromised
global msg_discord_scout_compromised:="Scout compromised? Status: "  

; Ingame
global msg_guild:="World Boss spawned: "

;============================================================================================================
; Approved unitscan NPCs
; THESE NEED TO BE ADDED TO UNITSCAN /unitscan npc
global whitelist_NPC :=["DOOMWALKER" ,"DOOM LORD KAZZAK"]