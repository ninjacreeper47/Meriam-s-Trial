extends GridContainer

@export var capacity = 6 
var essence_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	alchemy.experiment_nodes[0] = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_essence(val, type):
	essence_count += 1
	


func _remove_essence(val, type):
	essence_count -= 1

func _is_full():
	if(essence_count >= capacity):
		return true
	return false
