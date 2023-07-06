extends GridContainer

@export var exposed_count = 10
var essence = load("res://Essence.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.get_child_count() < exposed_count:
		var instance = essence.instantiate()
		add_child(instance)
