extends Popup

onready var delegate  = self 
#the delegate object can define the callback functions
#it should be set by the object creating the PauseDialog

func _draw():
	var r = Rect2($CenterContainer.rect_position,$CenterContainer.rect_size)
	draw_rect(r,Color(1,1,1,.5))

			
func _input(event):
	# continue if user hits ESC 
	if event.is_action("ui_cancel") and not event.is_pressed() : 
		get_tree().set_input_as_handled()
		_on_btn_continue_pressed()
	pass

func _on_btn_abandon_pressed():
	var response = {"message":"Cancel"}
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self,response)


func _on_btn_continue_pressed():
	var response = {"message":"Continue"}
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self,response)

