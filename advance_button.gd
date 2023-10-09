extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alchemy.labatory_stable && alchemy.active_experiments == 1:
		visible = true
	else:
		visible = false

func _on_pressed():
	if get_tree().get_current_scene().get_name() == "alchemypractice1":
		alchemy._clear_game_state()
		get_tree().change_scene_to_file("res://Levels/alchemypractice2.tscn")
	if get_tree().get_current_scene().get_name() == "alchemypractice2":
		alchemy._enter_game_from_tutorial()
