extends Control

var essence = load("res://Essence/Essence.tscn") 
var letter_square = load("res://Research Board/letter_square.tscn")
var column_clear_marker = load("res://Research Board/column_clear_marker.tscn")
@export var tableau:Control

@export var column_height = 8


@onready var board_total = get_child(0).get_child_count() * column_height

var column_counts = []

# Called when the node enters the scene tree for the first time.
func _ready():

	spawn_balanced()

#Fills the research area with new essences. 
#Randomization style:  Creates a bag which contains an equal amount of each type.
# Each spawned essence draws the next type from the bag.  Value is untouched
#If board total is not evenly divisble by amount of types, then the surplus are added to storage
func spawn_balanced():
	#bag creation
	var amount_of_each_type = (board_total / alchemy.type.size()) as int + 1
	var bag = []
	for i in range(amount_of_each_type):
		
		for t in alchemy.type:
			alchemy.essence_goal += 1
			bag.append(t)
	bag.shuffle()
	#essence spawning
	for i in range(get_child(0).get_child_count()):
		column_counts.append(0)
		var column = get_child(0).get_child(i)
		for j in range(column_height):
			var instance = essence.instantiate()
			column.add_child(instance)
			instance.my_col = i
			instance.in_upcoming = true
			instance._set_type(bag.pop_back())
			instance._set_value(alchemy.value_letters.pick_random())
			var my_call = Callable(self, "_on_next_requested")
			instance.taken_from_tableau.connect(my_call)
			my_call = Callable(self, "_on_taken_directly_from_upcoming")
			instance.taken_from_upcoming.connect(my_call)
			column_counts[i] += 1
		#populate the intial tableau
		_on_next_requested(i,false)
	#dump excess into storage
	var storage_ref = get_node("/root/Main/Game Screen/StorageContainer/StorageBackground/Storage")
	while bag.size() > 0:
		var instance = essence.instantiate()
		storage_ref.add_child(instance)
		storage_ref.essence_count += 1
		instance._set_type(bag.pop_back())
		instance._set_value(alchemy.value_letters.pick_random())
		instance.assigned_experiment = storage_ref
	alchemy.resetting_in_progress = false
	alchemy.game_playing = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _on_next_requested(column, spawn_replacement = true):
	var column_node = get_child(0).get_child(column)
	if column_counts[column] == 0:
		var instance = column_clear_marker.instantiate()
		tableau.add_child(instance)
		tableau.move_child(instance,column)
		return
	var request = column_node.get_child(column_node.get_child_count() -1)
	request.in_upcoming = false
	tableau._refill(request)
	column_counts[column] -= 1
	if spawn_replacement:
		var replacement = column_clear_marker.instantiate()
		column_node.add_child(replacement)
		column_node.move_child(replacement,1)
	

func _on_taken_directly_from_upcoming(column,essence):
	essence.in_upcoming = false
	var column_node = get_child(0).get_child(column)
	var replacement = column_clear_marker.instantiate()
	column_node.add_child(replacement)
	column_node.move_child(replacement,1)
	column_counts[column] -= 1
	
