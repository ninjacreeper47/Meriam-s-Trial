extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_game_pressed():
	alchemy.queue_reset = true
func _on_quit_pressed():
	get_tree().quit()
