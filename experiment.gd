extends GridContainer
var type_counts = {}
var value_counts = {}
var num_essences = 0

var active = false
var stable = true

#signals
signal kudu_breached
signal qluix_breached
signal stabilized
signal inactive
signal activated

@export var ex_num = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	alchemy.experiment_nodes.append(self)
	var call = Callable(self, "_check_laws")
	alchemy.alchemic_state_changed.connect(call)
	for i in range(alchemy.type.size()):
		type_counts[i] = 0
	for i in range (1,7):
		value_counts[i] = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_essence(val, type):
	type_counts[type] += 1
	value_counts[val] += 1
	num_essences+= 1
	alchemy.essence_counts[self.name] = num_essences
	if (active == false && num_essences >= 3):
		activated.emit()
		active = true
		alchemy.active_experiments += 1


func _remove_essence(val, type):
	type_counts[type] -= 1
	value_counts[val] -= 1
	num_essences-= 1
	alchemy.essence_counts[self.name] = num_essences
	if (active == true && num_essences < 3):
		active = false
		inactive.emit()
		alchemy.active_experiments -= 1

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
			kudu_breached.emit()	
			return false
	sum = 0
	for val in value_counts:
		sum += value_counts[val]
	for val in value_counts:
		if(sum - value_counts[val] < value_counts[val]):
			kudu_breached.emit()
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
				qluix_breached.emit()
				return false
	
	for val in value_counts:
		if value_counts[val] == 0:
			continue
		for innerval in value_counts:
			if val == innerval:
				continue
			if(value_counts[val] == value_counts[innerval]):
				qluix_breached.emit()
				return false
	return true

func _is_full():
	#Currently experiments do not have any hehaviour where they are considerd full. This function only exists so that
	#storage and experiments can elegantly use the same logic
	return false
	

