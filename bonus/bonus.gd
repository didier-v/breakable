
extends RigidBody2D

#autoload singletons
# global

var effect

func _ready():
	var sum=0 #sum of bonus coefficients
	for i in global.bonus_effect:
		sum+=global.bonus_effect[i]

	var choice = randi()%sum #with this we choose a bonus in the list
	sum=0
	effect =""
	for i in global.bonus_effect:
		sum+=global.bonus_effect[i] 
		if(choice<=sum) and effect =="":
			effect = i
	
	if(global.bonus_texture.has(effect)):
		$sprite.set_texture(global.bonus_texture[effect]) #the texture of the chosen bonus


#func _draw(): #for tests only
#	draw_circle(Vector2(),10,Color(0,0.8,0,1))
#

	
func start():
	set_linear_velocity(Vector2(0,150)) #immediate slow fall
	
	
	