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

func _can_drop_data(at_position, data):
	if _is_full():
		return false
	return true
	
func _drop_data(at_position, data):
	if data.assigned_experiment == self:
		return 
	if(data.assigned_experiment != null): 
		data.assigned_experiment._remove_essence(data.value,data.my_type)
	if(data.in_tableau):
		data.taken_from_tableau.emit(data.my_col)
		data.in_tableau = false
	data.assigned_experiment = self
	_add_essence(data.value,data.my_type)
	data.reparent(self)
	alchemy.alchemic_state_changed.emit()	
