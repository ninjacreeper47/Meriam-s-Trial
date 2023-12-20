extends HBoxContainer
var type_counts = {}
var value_counts = {}
var num_essences = 0

var largest_type
var smallest_type

var largest_value
var smallest_value

var unsorted_index = 0

var stable = true


@export var practice_experiment = false
var sorting_style = sort_type

enum {sort_none, sort_type,sort_value}
var my_children = []

var my_errors = []
@export var error_list_node:VBoxContainer
var TypeKuduErrorNode = load("res://Experiments/Experiment Errors/TypeKuduError.tscn")
var LetterKuduErrorNode = load("res://Experiments/Experiment Errors/LetterKuduError.tscn")
var MetaKuduErrorNode = load("res://Experiments/Experiment Errors/MetaKuduError.tscn")
var TypeQluixErrorNode = load("res://Experiments/Experiment Errors/TypeQluixError.tscn")
var LetterQluixErrorNode = load("res://Experiments/Experiment Errors/LetterQluixError.tscn")
var MetaQluixErrorNode = load("res://Experiments/Experiment Errors/MetaQluixError.tscn")

var type_transmutation_on = false
var value_transmutation_on = false


@export var essence_count_label :Label
#signals
signal broken 
signal stabilized


@export var ex_num = 0 


# Called when the node enters the scene tree for the first time.
func _ready():
	alchemy.experiment_nodes.append(self)
	for i in alchemy.type:
		type_counts[i] = 0
	for i in alchemy.value_letters:
		value_counts[i] = 0
	#only relevant if there are statically placed essences in the experiment at the scene level
	for child in self.get_children():
		for ess in child.get_children():
			_add_essence(ess.value,ess.my_type)
			ess.assigned_experiment = self
			unsorted_index += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_essence(val, type):
	type_counts[type] += 1
	value_counts[val] += 1
	num_essences+= 1
	if num_essences >= 1:
		alchemy.active_experiments += 1
	essence_count_label.text = "[" + str(num_essences) +"]"
	alchemy.essence_counts[ex_num] = num_essences
	alchemy.active_essence_count += 1
	
	_check_laws()

func _remove_essence(val, type):
	type_counts[type] -= 1
	value_counts[val] -= 1
	num_essences-= 1
	if num_essences < 1:
		alchemy.active_experiments -= 1
	essence_count_label.text = "[" + str(num_essences) +"]"
	alchemy.essence_counts[ex_num] = num_essences
	alchemy.active_essence_count -= 1
	
	_check_laws()
	
	
#This should be called whenever the essences in an experiment are changed
func _check_laws():
	_calculate_lowest_and_greatest()
	if practice_experiment:
		var kudu = _check_kudu()
		var qluix = _check_qluix()
		stable =  kudu && qluix
	else:
		# These functions must run for their side effects (generating ex errors).  I can not just call them in a string of && because of short circuit evaluation
		var kudu = _check_kudu()
		var qluix = _check_qluix()
		var meta = _check_meta()
		stable =  kudu && qluix && meta
	if stable:
		stabilized.emit()
	else:
		broken.emit()
	_update_error_list()

func _check_kudu():
	var breached = false
	var sum = 0
	for type in type_counts:
		sum += type_counts[type]
	for type in type_counts:
		if(sum - type_counts[type] < type_counts[type]):
			var _error =  TypeKuduError.new()
			_error._initialize(type)
			if _check_if_error_is_new(_error):
				var go = TypeKuduErrorNode.instantiate()
				go._initialize(type)
				error_list_node.add_child(go)
				go._init_graphics()
				my_errors.append(go)
			breached = true
	sum = 0
	for val in value_counts:
		sum += value_counts[val]
	for val in value_counts:
		if(sum - value_counts[val] < value_counts[val]):
			var _error =  LetterKuduError.new()
			_error._initialize(val)
			if _check_if_error_is_new(_error):
				var go = LetterKuduErrorNode.instantiate()
				go._initialize(val)
				error_list_node.add_child(go)
				go._init_graphics()
				my_errors.append(go)
			breached = true
	return !breached
func _check_qluix():
	var breached = false
	for type in type_counts:
		if type_counts[type] == 0:
			continue
		for innertype in type_counts:
			if type == innertype:
				continue
			if(type_counts[type] == type_counts[innertype]):
				breached = true
				var _error =  TypeQluixError.new()
				_error._initialize(type,innertype)
				if _check_if_error_is_new(_error):
					var go = TypeQluixErrorNode.instantiate()
					go._initialize(type,innertype)
					error_list_node.add_child(go)
					go._init_graphics()
					my_errors.append(go)
	
	for val in value_counts:
		if value_counts[val] == 0:
			continue
		for innerval in value_counts:
			if val == innerval:
				continue
			if(value_counts[val] == value_counts[innerval]):
				breached = true
				var _error =  LetterQluixError.new()
				_error._initialize(val,innerval)
				if _check_if_error_is_new(_error):
					var go = LetterQluixErrorNode.instantiate()
					go._initialize(val,innerval)
					error_list_node.add_child(go)
					go._init_graphics()
					my_errors.append(go)
	return !breached
func _check_meta():
	#meta is inactive
	if  alchemy.active_essence_count < alchemy.forced_meta_threshold:
		return true
	var breached = false
	#meta-qluix
	for ex in alchemy.essence_counts:
		if  ex == ex_num || alchemy.experiment_nodes[ex].num_essences == 0:
			continue
		if(alchemy.essence_counts[ex] == num_essences):
			breached = true
			var _error =  MetaQluixError.new()
			_error._initialize(ex_num,ex)
			if _check_if_error_is_new(_error):
				var go = MetaQluixErrorNode.instantiate()
				go._initialize(ex_num,ex)
				error_list_node.add_child(go)
				go._init_graphics()
				my_errors.append(go)
	#meta-kudu
	if(alchemy.active_essence_count - num_essences < num_essences):
		var _error =  MetaKuduError.new()
		_error._initialize(ex_num)
		if _check_if_error_is_new(_error):
			var go = MetaKuduErrorNode.instantiate()
			go._initialize(ex_num)
			error_list_node.add_child(go)
			go._init_graphics()
			my_errors.append(go)
		breached = true
	return !breached
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

func _on_sort_by_type_pressed():
	sorting_style = sort_type
	_sort_experiment()
func _on_sort_by_letter_pressed():
	sorting_style = sort_value
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

#Ties are resolved based off order of dictionary iteration.  
#They should never matter because transmutations require a stable experiment (no duplicate amounts)
func _calculate_lowest_and_greatest():
	var prev_lowest = 999
	var prev_highest = 0
	for key in type_counts:
		if type_counts[key] == 0:
			continue
		if type_counts[key] > prev_highest:
			largest_type = key
			prev_highest = type_counts[key]
		if type_counts[key] < prev_lowest:
			smallest_type = key
			prev_lowest = type_counts[key]
	prev_lowest = 999
	prev_highest = 0
	for key in value_counts:
		if value_counts[key] == 0:
			continue
		if value_counts[key] > prev_highest:
			largest_value = key
			prev_highest = value_counts[key]
		if value_counts[key] < prev_lowest:
			smallest_value = key
			prev_lowest = value_counts[key]

#swaps the lowest and largest [types and/or values]
func _transmute():
	if !stable:
		return
	if type_transmutation_on:
		for child in my_children:
			if child.my_type == largest_type:
				child._set_type(smallest_type)
			elif child.my_type == smallest_type:
				child._set_type(largest_type)
	if value_transmutation_on:
		for child in my_children:
			if child.value == largest_value:
				child._set_value(smallest_value)
			elif child.value == smallest_value:
				child._set_value(largest_value)
				
	_check_laws() #Nothing should have been broken by a transmutation, this just seems like a good idea


func _on_type_trans_toggle():
	type_transmutation_on = !type_transmutation_on

func _on_value_trans_toggle():
	value_transmutation_on = !value_transmutation_on

func _check_if_error_is_new(err:ExError):
	for e in my_errors:
		if err._is_same(e):
			return false
	return true

func _update_error_list():
	for e in my_errors:
		if !e._is_error_present_in_experiment(self):
			my_errors.erase(e)
			e.queue_free()

func _clear_error_list():
	for e in my_errors:
		e.queue_free()
	my_errors.clear()
