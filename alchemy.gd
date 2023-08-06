extends Node
#this script is autoloaded and is used to provide "global" values to other scripts 
var type = ["Metal","Plant","Star","Water","Friendship"]
var value_letters = ["A","B","C","D","E","F"]
var active_experiments  = 0
var experiment_nodes = ["storage placeholder"]
var essence_counts = {}
var selected_experiment

var active_type_counts = {}
var essence_goals ={}
var type_targets = {}
var labatory_stable = true


var forced_meta_threshold = 20
signal meta_breached
signal alchemic_state_changed
signal game_won
signal meta_counters_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	var	my_call = Callable(self,"_on_game_won")
	game_won.connect(my_call)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_input_checks()
	_update_alchemic_state()

#Sub function for _process
func _input_checks():
	#This line only exists so that i can arbitarily trigger this breakpoint
	if Input.is_action_just_pressed("debug"):
		print("AYAYA")
	if Input.is_action_just_pressed("SelectEx1"):
		selected_experiment = experiment_nodes[1]
	if Input.is_action_just_pressed("SelectEx2"):
		selected_experiment = experiment_nodes[2]
	if Input.is_action_just_pressed("SelectEx3"):
		selected_experiment = experiment_nodes[3]
	if Input.is_action_just_pressed("SelectEx4"):
		selected_experiment = experiment_nodes[4]
	if Input.is_action_just_pressed("SelectEx5"):
		selected_experiment = experiment_nodes[5]
	if Input.is_action_just_pressed("storage"):
		selected_experiment = experiment_nodes[0]
func _check_meta():
	
	if active_experiments < 3 && _count_active_essences() < forced_meta_threshold:
		return true
		#meta-qluix
	for count in essence_counts:
		if essence_counts[count] == 0:
			continue
		for innercount in essence_counts:
			if count == innercount:
				continue
			if(essence_counts[count] == essence_counts[innercount]):
				meta_breached.emit()
				return false
	#meta-kudu
	var sum = 0
	for count in essence_counts:
		sum += essence_counts[count]
	for count in essence_counts:
		if(sum - essence_counts[count] < essence_counts[count]):
			meta_breached.emit()
			return false
	return true
	
func _check_labatory_stability():
	for i in range(1, experiment_nodes.size()):
		if(experiment_nodes[i].stable == false && experiment_nodes[i].active == true):
			return false
	return true
func _update_alchemic_state():
	labatory_stable = _check_labatory_stability()
	meta_counters_updated.emit()
	_check_victory()
func _check_victory():
	if !_check_labatory_stability():
		return
	_count_active_essences()
	for i in type:
		if active_type_counts[i] >= essence_goals[i]:
			game_won.emit()
func _on_game_won():
	get_tree().change_scene_to_file("res://victory_celebration.tscn")

func _count_active_essences():
	var sum = 0
	for i in type:
		active_type_counts[i] = 0 
	for i in range(1, experiment_nodes.size()):
		for j in type:
			if experiment_nodes[i].active == false:
				continue
			active_type_counts[j] += experiment_nodes[i].type_counts[j]
			sum += experiment_nodes[i].type_counts[j]
	return sum
