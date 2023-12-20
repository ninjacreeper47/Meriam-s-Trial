extends Panel

var quitting_for_realizes = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game_pressed():
	alchemy.queue_reset = true
func _on_quit_pressed():

	if quitting_for_realizes:
		get_tree().quit()
	else:
		$QuitButton.text = "ARE YOU SURE?"
		quitting_for_realizes = true


func _on_quit_button_mouse_exited():
	quitting_for_realizes = false
	$QuitButton.text = "QUIT"

func _on_replay_tutorial_button_pressed():
	alchemy._clear_game_state()
	get_tree().change_scene_to_file("res://Levels/alchemypractice1.tscn")
