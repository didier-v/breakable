
extends Node

var global

func _ready():
	global = get_node("/root/global")
	global.load_menu()
