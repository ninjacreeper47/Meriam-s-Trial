extends Control

var essence = load("res://Essence.tscn") 
var letter_square = load("res://letter_square.tscn")
var column_clear_marker = load("res://column_clear_marker.tscn")
@export var tableau:Control

@export var column_height = 10


@onready var board_total = get_child(0).get_child_count() * column_height
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_balanced()

#Fills the research area with new essences. 
#Randomization style:  Creates a bag which contains an equal amount of each type.
# Each spawned essence draws the next type from the bag.  Value is untouched
#If board total is not evenly divisble by amount of types, it will pick one type to put surplus off in the bag
func spawn_balanced():
	#bag creation
	var types = alchemy.type.keys()
	var amount_of_each_type = (board_total / types.size()) as int
	var bag = []
	for i in range(amount_of_each_type):
		for type in types:
			if alchemy.essence_goals.has(alchemy.type[type]):
				alchemy.essence_goals[alchemy.type[type]] += 1
			else:
				alchemy.essence_goals[alchemy.type[type]] = 1
			bag.append(type)
	if bag.size() < board_total:
		var surplus_type = types.pick_random()
		for  i in range(board_total - bag.size()):
			bag.append(surplus_type)
			alchemy.essence_goals[alchemy.type[surplus_type]] += 1
	bag.shuffle()
	print(alchemy.essence_goals)
	#essence spawning
	for i in range(get_child(0).get_child_count()):
		var column = get_child(0).get_child(i)
		for j in range(column_height):
			var instance = essence.instantiate()
			column.add_child(instance)
			instance.my_col = i
			instance.in_upcoming = true
			instance._set_type(alchemy.type[bag.pop_back()])
			var my_call = Callable(self, "_on_next_requested")
			instance.taken_from_tableau.connect(my_call)
		#populate the intial tableau
		_on_next_requested(i)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _on_next_requested(column):
	var column_node = get_child(0).get_child(column)
	if column_node.get_child_count() <= 1:
		var instance = column_clear_marker.instantiate()
		tableau.add_child(instance)
		tableau.move_child(instance,column)
		return
	var request = column_node.get_child(column_node.get_child_count() -1)
	request.in_upcoming = false
	tableau._refill(request)
