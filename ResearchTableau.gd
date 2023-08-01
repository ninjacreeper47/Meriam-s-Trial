extends GridContainer

#If you change this you have to also modify upcomming essence manually!
var exposed_count = 8
var essence = load("res://Essence.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _refill(newEssence):
		newEssence.get_parent().remove_child(newEssence)
		add_child(newEssence)
		newEssence.in_tableau = true
		move_child(get_child(get_child_count() -1 ),newEssence.my_col)
