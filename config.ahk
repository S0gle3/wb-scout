; Feel free to edit any of these
;===========================================================================================================
global enable_demo_mode:=1        ; if 1 enables demo mode, sped up version of scout, uses test discord, party chat for alerts
                                  ; if 0 writes to praxis discord

global enable_duo_scout_mode:=0   ; enables/disables both scouting of 2 bosses, read README.md on how it works
                                  ; if 0 disables and only scouts 1 boss

global enable_log:=1              ; if 1 enables duo scouting

global use_macros:=0              ; if 1 uses macros bound to 1 and 5, instead of typing commands, 0 to disable

global is_rogue:=0 ; if 1 it sends 1 to press stealth when logging out/in
global is_stay_logged_in:=1 ; if 1 runs AFK script after succesful scouting, if 0 closes the game client after alerting

global wait_loading_screen:=13000 ; time in ms to wait on character -> world loading screen
global wait_character_screen:=9000 ; time in ms to wait on world -> character loading screen

;Timing
global num_cycles_movement := 22 ; 3
global sleep_cycle_duration := 5000 ; 5000
global num_cycles_relog := 80 ; 80
if (enable_demo_mode = 1){
    num_cycles_movement := 5 ; 5
    sleep_cycle_duration := 500 ; 1000
	num_cycles_relog := 10 ; 10
}
;Timing Duo Swap
global num_cycles_before_duo_swap:= 6 ; enable_duo_scout_mode must be set to 1 (enabled)
                                      ; must be true num_cycles_before_duo_swap < num_cycles_relog
global is_next_character_down:=1 ; if 1 swapping characters pressed down arrow key on char select
                                 ; if 0 presses up arrow key
if (enable_demo_mode = 1){
    num_cycles_before_duo_swap:= 3 ; 3 
}

;============================================================================================================
; Discord spam
global discord_channel_spam:="ahk-test-coordination"
if (enable_demo_mode = 0){
    discord_channel_spam:="#coordination world" ; "#coordination world" as to not confuse with warchief coordination
}
;global discord_channel_spam:="#coordination world" ; "#coordination world" as to not confuse with warchief coordination
global msg_discord:="WORLD BOSS SPAWNED " 
global spam_delay:=1000 ; spam delay in ms 
global n_spam:=3    ; number of messages to send        

; Discord bot
global discord_channel_bot:="#ahk-test-bot-pings"
if (enable_demo_mode = 0){
    discord_channel_bot:="#bot-pings"
}
global msg_discord_bot_cmd_doomwalker:="!startevent doomwalker" 
global msg_discord_bot_cmd_kazzak:="!startevent kazzak" 

global msg_discord_everyone_doomwalker:="DOOMWALKER SPAWNED @everyone" 
global msg_discord_everyone_kazzak:="KAZZAK SPAWNED @everyone" 

; Discord scout compromised
global msg_discord_scout_compromised:="Scout compromised? Status: "  

; Ingame
global msg_ingame:="/w Sogla TEST_SCOUT: " ; must have space at the end
if (enable_demo_mode = 0){
   msg_ingame:="/guild SCOUT: "
}

;============================================================================================================
; Approved unitscan NPCs
global whitelist_NPC :=["DOOMWALKER" ,"DOOM LORD KAZZAK"] ; ALL CAPS