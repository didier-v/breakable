
extends Node2D

#autoload singletons
# global
# nc

func _ready():
	nc.add_observer(self,"show_bonus_message","show_bonus_message")

func _exit_tree():
	nc.remove_observer(self,"show_bonus_message") 

func set_score(score):
	$score.text = str(score)

func set_multiplier(multiplier):
	$multiplier.text = "x"+str(multiplier).pad_zeros(2)
	if(multiplier>1):
		$multiplier_animation.play("multiplier")

func set_lifes(lifes):
	$lifes.text = str(lifes).pad_zeros(2)

func  show_bonus_message(observer, notificationName,effect):
	$message.text = global.bonus_message[effect]
	$message_animation.play("message")
