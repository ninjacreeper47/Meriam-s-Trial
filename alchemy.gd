extends Node
#this script is autoloaded and is used to provide "global" values to other scripts 
enum type {Metal,Plant,Star,Water,Friendship}
var active_experiments  = 0
var experiment_nodes = ["storage placeholder"]
var essence_counts = {}
var selected_experiment

var labatory_stable = true
signal meta_breached
signal alchemic_state_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	if active_experiments < 3:
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
		if(experiment_nodes[i].stable == false):
			return false
	return true
