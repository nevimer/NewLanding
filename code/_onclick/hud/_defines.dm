/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	In addition, the keywords TOP, BOTTOM, RIGHT, LEFT and CENTER can be used to represent their respective
	screen borders. TOP-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/proc/ui_hand_position(i) //values based on old hand ui positions (CENTER:-/+16,BOTTOM:5)
	var/x_off = -(!(i % 2))
	var/y_off = round((i-1) / 2)
	return "CENTER+[x_off]:16,BOTTOM+[y_off]:5"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,BOTTOM+1:5)
	return "CENTER:-16,BOTTOM+[y_off+1]:5"

/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,BOTTOM+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	return "CENTER+[x_off]:16,BOTTOM+[y_off+1]:5"

//Lower left, persistent menu
#define ui_inventory "LEFT:6,BOTTOM:5"

//Middle left indicators
#define ui_lingchemdisplay "LEFT,CENTER-1:15"
#define ui_lingstingdisplay "LEFT:6,CENTER-3:11"

//Lower center, persistent menu
#define ui_sstore1 "CENTER-5:10,BOTTOM:5"
#define ui_id "CENTER-4:12,BOTTOM:5"
#define ui_belt "CENTER-3:14,BOTTOM:5"
#define ui_back "CENTER-2:14,BOTTOM:5"
#define ui_storage1 "CENTER+1:18,BOTTOM:5"
#define ui_storage2 "CENTER+2:20,BOTTOM:5"
#define ui_combo "CENTER+4:24,BOTTOM+1:7" //combo meter for martial arts

//Lower right, persistent menu
#define ui_drop_throw "RIGHT-1:28,BOTTOM+1:7"
#define ui_above_movement "RIGHT-2:26,BOTTOM+1:7"
#define ui_above_intent "RIGHT-3:24, BOTTOM+1:7"
#define ui_movi "RIGHT-2:26,BOTTOM:5"
#define ui_acti "RIGHT-3:24,BOTTOM:5"
#define ui_combat_toggle "RIGHT-3:24,BOTTOM:5"
#define ui_zonesel "RIGHT-1:28,BOTTOM:5"
#define ui_acti_alt "RIGHT-1:28,BOTTOM:5" //alternative intent switcher for when the interface is hidden (F12)
#define ui_crafting "RIGHT-4:22,BOTTOM:5"
#define ui_building "RIGHT-4:22,BOTTOM:21"
#define ui_language_menu "RIGHT-4:6,BOTTOM:21"
#define ui_skill_menu "RIGHT-4:22,BOTTOM:5"

//Upper-middle right (alerts)
#define ui_alert1 "RIGHT-1:28,CENTER+5:27"
#define ui_alert2 "RIGHT-1:28,CENTER+4:25"
#define ui_alert3 "RIGHT-1:28,CENTER+3:23"
#define ui_alert4 "RIGHT-1:28,CENTER+2:21"
#define ui_alert5 "RIGHT-1:28,CENTER+1:19"

//Middle right (status indicators)
#define ui_healthdoll "RIGHT-1:28,CENTER-2:13"
#define ui_health "RIGHT-1:28,CENTER-1:15"
#define ui_stamina "RIGHT-1:28,CENTER:17"

//Pop-up inventory
#define ui_shoes "LEFT+1:8,BOTTOM:5"
#define ui_iclothing "LEFT:6,BOTTOM+1:7"
#define ui_oclothing "LEFT+1:8,BOTTOM+1:7"
#define ui_gloves "LEFT+2:10,BOTTOM+1:7"
#define ui_glasses "LEFT:6,BOTTOM+3:11"
#define ui_mask "LEFT+1:8,BOTTOM+2:9"
#define ui_ears "LEFT+2:10,BOTTOM+2:9"
#define ui_neck "LEFT:6,BOTTOM+2:9"
#define ui_head "LEFT+1:8,BOTTOM+3:11"

//Generic living
#define ui_living_pull "RIGHT-1:28,CENTER-3:15"
#define ui_living_healthdoll "RIGHT-1:28,CENTER-1:15"

//Monkeys
#define ui_monkey_head "CENTER-5:13,BOTTOM:5"
#define ui_monkey_mask "CENTER-4:14,BOTTOM:5"
#define ui_monkey_neck "CENTER-3:15,BOTTOM:5"
#define ui_monkey_back "CENTER-2:16,BOTTOM:5"

//Ghosts
#define ui_ghost_spawners_menu "BOTTOM:6,CENTER-2:24"
#define ui_ghost_orbit "BOTTOM:6,CENTER-1:24"
#define ui_ghost_reenter_corpse "BOTTOM:6,CENTER:24"
#define ui_ghost_teleport "BOTTOM:6,CENTER+1:24"
#define ui_ghost_pai "BOTTOM: 6, CENTER+2:24"
#define ui_ghost_language_menu "BOTTOM: 22, CENTER+3:8"

//Blobbernauts
#define ui_blobbernaut_overmind_health "RIGHT-1:28,CENTER+0:19"

