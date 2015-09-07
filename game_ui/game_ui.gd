
extends Node2D

#autoload
var global
var nc

func _ready():
	global = get_node("/root/global")
	nc = get_node("/root/nc")
	nc.add_observer(self,"show_bonus_message","show_bonus_message")

func _exit_tree():
	nc.remove_observer(self,"show_bonus_message") 

func set_score(score):
	get_node("score").set_text(str(score))

func set_multiplier(multiplier):
	get_node("multiplier").set_text("x"+str(multiplier).pad_zeros(2))
	if(multiplier>1):
		get_node("multiplier_animation").play("multiplier")

func set_lifes(lifes):
	get_node("lifes").set_text(str(lifes).pad_zeros(2))

func  show_bonus_message(observer, notificationName,effect):
	get_node("message").set_text(global.bonus_message[effect])
	get_node("message_animation").play("message")
