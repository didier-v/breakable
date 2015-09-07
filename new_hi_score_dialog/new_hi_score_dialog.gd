extends Popup


var delegate
var score setget setScore

func _ready():
	var line_edit = get_node("CenterContainer/VBoxContainer/LineEdit")
	line_edit.select_all()
	line_edit.grab_focus()

func _on_ButtonOK_pressed():
	var name = get_node("CenterContainer/VBoxContainer/LineEdit").get_text()
	delegate.close_hi_score_dialog(self,name)

func setScore(newScore):
	score = newScore
	get_node("CenterContainer/VBoxContainer/scoreLabel").set_text(str(score))

