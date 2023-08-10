extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_bars()

func _update_bars():
	get_child(0).get_child(0).value = alchemy.active_type_counts["Metal"]
	get_child(1).get_child(0).value = alchemy.active_type_counts["Plant"]
	get_child(2).get_child(0).value = alchemy.active_type_counts["Star"]
	get_child(3).get_child(0).value = alchemy.active_type_counts["Water"]
	get_child(4).get_child(0).value = alchemy.active_type_counts["Friendship"]
