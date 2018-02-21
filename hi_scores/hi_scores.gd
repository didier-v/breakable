
extends Node

#autoload singletons
# global
# hsm

func _ready():
	var i=1
	var pos_text=""
	var name_text=""
	var score_text=""

	for i in range (hsm.score_names.size()): #read the current list
		var pos_label = Label.new()
		pos_label.text = str(i+1)+"."
		pos_label.align = Label.ALIGN_RIGHT

		pos_text = pos_text+str(i+1)+".\n"
		
		var name_label = Label.new()
		name_label.text = hsm.score_names[i]
		name_label.set_size(Vector2(800,30))
		name_text = name_text+hsm.score_names[i]+"\n"

		var score_label = Label.new()
		score_label.text = str(hsm.score_values[i])
		score_label.align = Label.ALIGN_RIGHT
		score_text = score_text+str(hsm.score_values[i])+"ı•\n"

	#list is made of 3 text nodes
	$VBoxContainer/GridContainer/Pos.text = pos_text
	$VBoxContainer/GridContainer/Name.text = name_text
	$VBoxContainer/GridContainer/Score.text = score_text

func _on_MainMenu_pressed():
	global.load_menu()
