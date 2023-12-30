extends Node
#this script is autoloaded and is used to provide "global" values and logic  to other scripts 
var type = ["Metal","Plant","Star","Water","Friendship"]
var value_letters = ["A","B","C","D","E","F"]
var active_experiments  = 0 #This variable should be vestgial. Not deleting it because I might decide to care about it again
var experiment_nodes = ["storage placeholder"]
var essence_counts = {}
var selected_experiment

var active_essence_count = 0
var essence_goal = 0
var resetting_in_progress = false
var labatory_stable = true

var game_playing = false
var queue_reset = false

var practice_environment = false
var forced_meta_threshold = 20

var new_player_entering = false

var debug_research_locking_disabled = false


var student_game = false
signal game_won
signal meta_counters_updated


func _enter_game_from_tutorial():
	alchemy._clear_game_state()
	new_player_entering = true
	get_tree().change_scene_to_file("res://Levels/main.tscn")

func _reset():
	resetting_in_progress = true
	_clear_game_state()
	get_tree().unload_current_scene()
	get_tree().change_scene_to_file("res://Levels/main.tscn")
	queue_reset = false
	#$Research.get_child(0)._spawn_balanced()
# Called when the node enters the scene tree for the first time.
func _ready():
	var	my_call = Callable(self,"_on_game_won")
	game_won.connect(my_call)
	_clear_game_state()
	
func _clear_game_state():
	experiment_nodes = ["storage placeholder"]
	essence_counts.clear()
	active_essence_count = 0
	labatory_stable = true
	practice_environment = false
	essence_goal = 0
	active_experiments = 0
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
	if Input.is_action_just_pressed("restart") || queue_reset == true:
		_reset()
	if Input.is_action_just_pressed("debug_disable_locking"):
		debug_research_locking_disabled  = !debug_research_locking_disabled
	if Input.is_action_just_pressed("debug_win"):
		game_won.emit()

	
func _check_labatory_stability():
	var stability = true
	for i in range(1, experiment_nodes.size()):
		if experiment_nodes[i].practice_experiment == true:
			practice_environment = true
		experiment_nodes[i]._check_laws()
		if(experiment_nodes[i].stable == false):
			stability = false
	return stability
func _update_alchemic_state():
	labatory_stable = _check_labatory_stability()
	meta_counters_updated.emit()
	_check_victory()
func _check_victory():
	if !_check_labatory_stability():
		return
	if practice_environment:
		return
	if  active_essence_count >= essence_goal:
			game_won.emit()
func _on_game_won():
	game_playing = false

