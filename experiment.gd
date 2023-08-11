extends HBoxContainer
var type_counts = {}
var value_counts = {}
var num_essences = 0

var unsorted_index = 0

var active = false
var stable = true

var sorting_style = sort_none
#make sure the option drop down matches this order oomfie
enum {sort_none, sort_type,sort_value}
var my_children = []


@export var essence_count_label :Label
#signals
signal kudu_breached(dominant)
signal qluix_breached(equal1,equal2)
signal stabilized
signal inactive
signal activated

@export var ex_num = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	alchemy.experiment_nodes.append(self)
	for i in alchemy.type:
		type_counts[i] = 0
	for i in alchemy.value_letters:
		value_counts[i] = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_essence(val, type):
	type_counts[type] += 1
	value_counts[val] += 1
	num_essences+= 1
	essence_count_label.text = "[" + str(num_essences) +"]"
	alchemy.essence_counts[ex_num] = num_essences
	if (active == false && num_essences >= 3):
		activated.emit()
		active = true
		alchemy.active_experiments += 1
	_check_laws()
func _remove_essence(val, type):
	type_counts[type] -= 1
	value_counts[val] -= 1
	num_essences-= 1
	essence_count_label.text = "[" + str(num_essences) +"]"
	alchemy.essence_counts[ex_num] = num_essences
	if (active == true && num_essences < 3):
		active = false
		inactive.emit()
		alchemy.active_experiments -= 1
	_check_laws()
	
	

func _check_laws():
	if !active:
		stable = true
		return
	stable =  _check_kudu() && _check_qluix() && alchemy._check_meta()
	if stable:
		stabilized.emit()

func _check_kudu():
	var sum = 0
	for type in type_counts:
		sum += type_counts[type]
	for type in type_counts:
		if(sum - type_counts[type] < type_counts[type]):
			kudu_breached.emit(type)
			return false
	sum = 0
	for val in value_counts:
		sum += value_counts[val]
	for val in value_counts:
		if(sum - value_counts[val] < value_counts[val]):
			kudu_breached.emit(val)
			return false
	return true
func _check_qluix():
	for type in type_counts:
		if type_counts[type] == 0:
			continue
		for innertype in type_counts:
			if type == innertype:
				continue
			if(type_counts[type] == type_counts[innertype]):
				qluix_breached.emit(type,innertype)
				return false
	
	for val in value_counts:
		if value_counts[val] == 0:
			continue
		for innerval in value_counts:
			if val == innerval:
				continue
			if(value_counts[val] == value_counts[innerval]):
				qluix_breached.emit(val,innerval)
				return false
	return true

func _is_full():
	#Currently experiments do not have any hehaviour where they are considerd full. This function only exists so that
	#storage and experiments can elegantly use the same logic
	return false
	
func _can_drop_data(at_position, data):
	if _is_full():
		return false
	return true
	
func _drop_data(at_position, data):
	if data.assigned_experiment == self:
		return 
	_assign_new_child(data) #should be done before sorting
	if(data.assigned_experiment != null): 
		data.assigned_experiment._remove_essence(data.value,data.my_type)
		data.assigned_experiment.my_children.erase(data)
		data.assigned_experiment._sort_experiment()
	if(data.in_tableau):
		data.taken_from_tableau.emit(data.my_col)
		data.in_tableau = false
	data.assigned_experiment = self
	
	_add_essence(data.value,data.my_type)
	_sort_experiment()
	

func _sort_experiment():
	unsorted_index = 0
	for child in my_children:
		_assign_child(child)
func _on_sort_choice_item_selected(index):
	sorting_style = index
	_sort_experiment()


func _assign_new_child(incoming_ess):
	my_children.append(incoming_ess)
	_assign_child(incoming_ess)

func _assign_child(incoming_ess):
	if sorting_style == sort_none:
		incoming_ess.reparent(get_child(unsorted_index % 6))
		unsorted_index += 1
	if sorting_style == sort_value:
		incoming_ess.reparent(get_child(alchemy.value_letters.find(incoming_ess.value)))
	if sorting_style == sort_type:
		incoming_ess.reparent(get_child(alchemy.type.find(incoming_ess.my_type)))
