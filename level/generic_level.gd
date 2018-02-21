extends Reference

var separation
var brick


func _init():
	brick = load("res://static_brick/static_brick.tscn")
	separation=1


func init_level(level_node):
	#each level file must define this function
	pass