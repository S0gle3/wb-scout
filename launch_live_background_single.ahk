#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include config.ahk
enable_demo_mode:=0   
enable_duo_scout_mode:=0 	  
is_next_character_down:=1	  
scout_in_background:=1 
push_options()
#include lib\msg_box.ahk
#include lib\scout.ahk
#include scout_f12_foreground.ahk