extends Node2D

#autoload
var global
var hsm

func _ready():
	global = get_node("/root/global")
	hsm = get_node("/root/hi_scores_manager")
	
	get_node("CenterContainer/VBoxContainer/Score").set_text(tr("SCORE")+" : "+str(global.score))

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	 #if current score better than lowest score in the list, open new hi score dialog
	if(global.score>hsm.get_lowest_hi_score()):
		var hiScoreDialog  = get_node("CenterContainer/HiScoreDialog")
		hiScoreDialog.delegate = self
		hiScoreDialog.score = global.score
		hiScoreDialog.popup_centered()
	

func _on_play_again_pressed():
	global.new_game()

func _on_main_menu_pressed():
	global.load_menu()


#HI SCORE DIALOG DELEGATE
func close_hi_score_dialog(dialog,name):
	dialog.hide()
	hsm.add_hi_score(name,global.score)
	