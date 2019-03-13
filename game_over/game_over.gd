extends Node

#autoload singletons
# global
# hsm (hi scores manager)

func _ready():
	var debug = false
	$CenterContainer/VBoxContainer/score.text = tr("SCORE")+" : "+str(global.score)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	 #if current score better than lowest score in the list, open new hi score dialog
	if(global.score>hsm.get_lowest_hi_score() or debug):
		$hi_score_dialog.delegate = self
		$hi_score_dialog.score = global.score
		$hi_score_dialog.show_modal(true)
		$hi_score_dialog.show()

func _on_play_again_pressed():
	global.new_game()

func _on_main_menu_pressed():
	global.load_menu()

#HI SCORE DIALOG DELEGATE
func close_hi_score_dialog(dialog,playername):
	dialog.hide()
	hsm.add_hi_score(playername,global.score)
