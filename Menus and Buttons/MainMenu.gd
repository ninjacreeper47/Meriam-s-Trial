extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tutorial_button_pressed():
	alchemy._clear_game_state()
	alchemy.game_playing = true
	get_tree().change_scene_to_file("res://Levels/alchemypractice1.tscn")

func _on_play_game_button_pressed():
	alchemy._clear_game_state()
	alchemy.game_playing = true
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
