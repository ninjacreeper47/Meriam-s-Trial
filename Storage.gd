extends GridContainer

@export var capacity = 8 
var essence_count = 0

#this variable exists for more polymorphism abuse, this is really getting out of hand and i should just refactor 
#storage to not be considered an experiment
var my_children =[]
# Called when the node enters the scene tree for the first time.
func _ready():
	alchemy.experiment_nodes[0] = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PlaytestIncreaseStorageCapacity"):
		capacity += 1

func _add_essence(val, type):
	essence_count += 1
	


func _remove_essence(val, type):
	essence_count -= 1

func _is_full():
	if(essence_count >= capacity):
		return true
	return false

#polymorphism abuse.  Storage is treated as an experiment to drag/drop behavior and essence clicking.  This function exists so the logic can cleanly call it without checking if it's storage first
func _sort_experiment():
	return
func _can_drop_data(at_position, data):
	if _is_full():
		return false
	return true
	
func _drop_data(at_position, data):
	if data.assigned_experiment == self:
		return 
	if(data.assigned_experiment != null): 
		data.assigned_experiment._remove_essence(data.value,data.my_type)
		data.assigned_experiment.my_children.erase(data)
		data.assigned_experiment._sort_experiment()
	if(data.in_tableau):
		data.taken_from_tableau.emit(data.my_col)
		data.in_tableau = false
	data.assigned_experiment = self
	_add_essence(data.value,data.my_type)
	data.reparent(self)

	
func _assign_new_child(incoming_ess):
	incoming_ess.reparent(self)
