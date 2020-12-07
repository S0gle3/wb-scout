global enable_log:=1                            ; if 1 writes to a log file, 0 to disable

global use_macros:=0                            ; if 1 uses macros bound to 1 and 5, instead of typing commands, 0 to disable

global is_rogue:=1 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=0 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting

global wait_loading_screen:=21000                ; time in ms to wait on character -> world loading screen

;============================================================================================================
; Discord spam
global discord_channel_spam:="#coordination world" ; "#coordination world" as to not confuse with warchief coordination
global msg_discord:="World Boss spawned: " 
global spam_delay:=1000 ; spam delay in ms 
global n_spam:=3    ; number of messages to send        

; Discord bot
global discord_channel_bot:="#scout-bot-channel"
global msg_discord_bot_cmd_azuregos:="start bot azuregos" 
global msg_discord_bot_cmd_kazzak:="start bot kazzak" 
global msg_discord_bot_cmd_dragons:="start bot dragons" 

; Ingame
global msg_guild:="(ALERT) World Boss spawned: "

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
