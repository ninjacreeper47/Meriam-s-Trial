extends Node
#this script is autoloaded and is used to provide "global" values to other scripts 
var type = ["Metal","Plant","Star","Water","Friendship"]
var value_letters = ["A","B","C","D","E","F"]
var active_experiments  = 0 #This variable should be vestgial. Not deleting it because I might decide to care about it again
var experiment_nodes = ["storage placeholder"]
var essence_counts = {}
var selected_experiment

var active_type_counts = {}
var essence_goals ={}
var resetting_in_progress = false
var labatory_stable = true

var game_playing = true
var queue_reset = false
var forced_meta_threshold = 20

var debug_research_locking_disabled = false
#this should be set to true when the expert scene loads
var expert_difficulty = false
signal meta_breached(law_broken,ex1, ex2)
signal game_won
signal meta_counters_updated

func _reset():
	resetting_in_progress = true
#	active_experiments = 0
	experiment_nodes = ["storage placeholder"]
	essence_counts.clear()
	active_type_counts.clear()
	labatory_stable = true
	for goal in essence_goals.keys():
		essence_goals[goal] = 0
	#essence_goals.clear()
	get_tree().unload_current_scene()
	if (expert_difficulty):
		get_tree().change_scene_to_file("res://Levels/expert_game.tscn")
	else:
		get_tree().change_scene_to_file("res://Levels/main.tscn")
	queue_reset = false
	#$Research.get_child(0)._spawn_balanced()
# Called when the node enters the scene tree for the first time.
func _ready():
	var	my_call = Callable(self,"_on_game_won")
	game_won.connect(my_call)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_input_checks()
	if !resetting_in_progress && game_playing:
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
	if Input.is_action_just_pressed("restart") || queue_reset == true:
		_reset()
	if Input.is_action_just_pressed("debug_disable_locking"):
		debug_research_locking_disabled  = !debug_research_locking_disabled
	if Input.is_action_just_pressed("debug_win"):
		game_won.emit()
func _check_meta():
	
	#meta is inactive
	if  _count_active_essences() < forced_meta_threshold:
		return true
		
	#meta-qluix
	for count in essence_counts:
		if essence_counts[count] == 0 || experiment_nodes[count].active == false:
			continue
		for innercount in essence_counts:
			if count == innercount || experiment_nodes[innercount].active == false:
				continue
			if(essence_counts[count] == essence_counts[innercount]):
				meta_breached.emit(1,count,innercount)
				return false
	#meta-kudu
	var sum = 0
	for count in essence_counts:
		if experiment_nodes[count].active == true:
			sum += essence_counts[count]
	for count in essence_counts:
		if(sum - essence_counts[count] < essence_counts[count]) && experiment_nodes[count].active == true:
			meta_breached.emit(2,count,-1)
			return false
	#passed all metachecks
	return true
	
func _check_labatory_stability():
	for i in range(1, experiment_nodes.size()):
		experiment_nodes[i]._check_laws()
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
	game_playing = false

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
