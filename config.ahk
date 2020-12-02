global enable_log:=1							; if 1 writes to a log file, 0 to disable

global use_macros:=0							; if 1 uses macros 1-5 setup instead of typing commands, 0 to disable

global is_rogue:=1 ; if 1 it sends 1 to press stealth when logging out/in

global wait_loading_screen:=26000				; time in ms to wait on character -> world loading screen

;============================================================================================================
; Discord spam
global discord_channel_spam:="#scout-bot-spam"
global msg_discord:="Discord this NPC spawned: " 
global spam_delay:=1500 ; spam delay in ms 
global n_spam:=10	; number of messages to send		

; Discord bot
global discord_channel_bot:="#scout-bot-channel"
global msg_discord_bot_cmd_azuregos:="start bot" 
global msg_discord_bot_cmd_kazzak:="start bot kazzak" 
global msg_discord_bot_cmd_dragons:="start bot" 

; Ingame
global msg_guild:="(ALERT) NPC spawned: "

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
