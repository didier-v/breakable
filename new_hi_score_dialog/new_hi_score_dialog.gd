extends Panel


var delegate #defined
var score setget setScore

func _ready():
	var line_edit = $CenterContainer/VBoxContainer/LineEdit
	line_edit.select_all()
	line_edit.grab_focus()

func _on_ButtonOK_pressed():
	var playername = $CenterContainer/VBoxContainer/LineEdit.text
	if delegate.has_method("close_hi_score_dialog"):
		delegate.close_hi_score_dialog(self,playername)

func setScore(newScore):
	$CenterContainer/VBoxContainer/score_label.text = str(newScore)

