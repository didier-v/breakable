
extends Popup

var global
var delegate  #the delegate object can define the callback functions

func _ready():
	global = get_node("/root/global")
	set_process_input(true)
	delegate = self # should be set by the object creating the PauseDialog
	
func _draw():
	draw_rect(self.get_item_rect(),Color(1,1,1,.5))
	
func _input(event):
	# continue if user hits ESC 
	if event.is_action("ui_cancel") and not event.is_pressed() : 
		get_tree().set_input_as_handled()
		set_process_input(false)
		_on_Continue_pressed()

func _on_Abandon_pressed():
	var response = {"message":"Cancel"}
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self,response)


func _on_Continue_pressed():
	var response = {"message":"Continue"}
	if delegate.has_method("close_dialog"):
		delegate.close_dialog(self,response)

