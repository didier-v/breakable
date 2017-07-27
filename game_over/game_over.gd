extends Node2D

#autoload singletons
# global
# hsm (hi scores manager

func _ready():
	var debug = true
	get_node("CenterContainer/VBoxContainer/Score").set_text(tr("SCORE")+" : "+str(global.score))

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	 #if current score better than lowest score in the list, open new hi score dialog
	if(global.score>hsm.get_lowest_hi_score() or debug):
		var hiScoreDialog  = get_node("HiScoreDialog")
		hiScoreDialog.delegate = self
		hiScoreDialog.score = global.score
		hiScoreDialog.show_modal(true)
		hiScoreDialog.show()
		
	

func _on_play_again_pressed():
	global.new_game()

func _on_main_menu_pressed():
	global.load_menu()


#HI SCORE DIALOG DELEGATE
func close_hi_score_dialog(dialog,name):
	dialog.hide()
	hsm.add_hi_score(name,global.score)
	