
extends Node

var global

func _ready():
	global = get_node("/root/global")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #always show the mouse in this scene

func _on_btn_new_game_pressed():
	global.new_game()

func _on_btn_hi_scores_pressed():
	global.load_hi_scores()

func _on_btn_options_pressed():
	global.load_options()

func _on_btn_quit_pressed():
	global.quit()
