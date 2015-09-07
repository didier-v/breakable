
extends Node

#autoload
var global
var hsm

func _ready():
	#autoload
	global = get_node("/root/global")
	hsm = get_node("/root/hi_scores_manager")

	#list is made of 3 text nodes
	var pos=get_node("VBoxContainer/GridContainer/pos")
	var name=get_node("VBoxContainer/GridContainer/name")
	var score=get_node("VBoxContainer/GridContainer/score")

	var i=1
	var posText=""
	var nameText=""
	var scoreText=""

	for i in range (hsm.score_names.size()): #read the current list
		var posLabel = Label.new()
		posLabel.set_text(str(i+1)+".")
		posLabel.set_align(Label.ALIGN_RIGHT)

		posText = posText+str(i+1)+".\n"
		
		var namelabel = Label.new()
		namelabel.set_text(hsm.score_names[i])
		namelabel.set_size(Vector2(800,30))
		nameText = nameText+hsm.score_names[i]+"\n"

		var scorelabel = Label.new()
		scorelabel.set_text(str(hsm.score_values[i]))
		scorelabel.set_align(Label.ALIGN_RIGHT)
		scoreText = scoreText+str(hsm.score_values[i])+"ı•\n"

	pos.set_text(posText)
	name.set_text(nameText)
	score.set_text(scoreText)

func _on_main_menu_pressed():
	global.load_menu()
