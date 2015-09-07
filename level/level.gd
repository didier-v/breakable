
extends Node2D

var global

var total_bricks setget set_total_bricks, get_total_bricks
var lb

func load_level(level):
	var level_builder=load("res://level/"+str(level)+".gd")
	lb = level_builder.new()
	for i in range (get_child_count()):
		get_child(i).queue_free()
	total_bricks=lb.init_level(self,global)
	

func _ready():
	global = get_node("/root/global")



func set_total_bricks(tb):
	total_bricks=tb
	
func get_total_bricks():
	return total_bricks
	