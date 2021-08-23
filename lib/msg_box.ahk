live_warning:="LIVE Script loaded!"
if (enable_demo_mode=1) {
	live_warning:="Test Script loaded."
}
scout_relog_in_background_warning:=""
if (scout_relog_in_background=1) {
	scout_relog_in_background_warning:="does NOT alert discord!!!"
}
msg_box_txt =
(
{}

To Begin Scouting:   
	1. Press F12 to start/pause scouting
	2. Press CTRL+F12 to exit script
	
Custom Options from config.ahk:
	enable_demo_mode:={}
	scout_relog_in_background:={} {}
	enable_duo_scout_mode:={}
	is_rogue:={}
	is_stay_logged_in:={}
)
msg_box_txt := Format(msg_box_txt,live_warning,enable_demo_mode,scout_relog_in_background,scout_relog_in_background_warning,enable_duo_scout_mode,is_rogue,is_stay_logged_in)