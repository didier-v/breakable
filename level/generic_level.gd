extends Reference

var separation
var brique


func _init():
	brique = load("res://static_brick/static_brick.scn")
	separation=1


func init_level(levelNode,global):
	#each level file must define this function
	pass