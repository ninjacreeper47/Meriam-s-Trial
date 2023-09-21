extends TextureButton

#Essense Attributes
@export_enum("A","B","C","D","E","F" ) var value :String
@export_enum("Metal","Plant","Star","Water","Friendship") var my_type :String 



var in_tableau = false
var in_upcoming = false #This should be set by the upcomming essence!
var my_col:int
@onready var experiment_list = get_tree().get_nodes_in_group("Experiments") 
var assigned_experiment 

signal taken_from_tableau


# Called when the node enters the scene tree for the first time.
func _ready():
	_generateIcon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 

func _set_type(type):
	my_type = type
	_generateIcon()
func _set_value(v):
	value = v
	_generateIcon()
func _pickValue():
	return randi() % 6 + 1
	
func _generateIcon():
	
	var type_iconpath = "res://Assets/%s.svg"
	type_iconpath = type_iconpath % my_type
	texture_normal = load(type_iconpath)
	get_child(0).text = str(value)


func _on_pressed():
	if _check_if_locked():
		return
	if assigned_experiment == alchemy.selected_experiment:
		return  
	if(alchemy.selected_experiment._is_full() == true):
		return 
	alchemy.selected_experiment._assign_new_child(self)
	if(assigned_experiment != null):
		assigned_experiment._remove_essence(value,my_type)
		assigned_experiment.my_children.erase(self)
		assigned_experiment._sort_experiment()
	if(in_tableau):
		taken_from_tableau.emit(my_col)
		in_tableau = false
	
	alchemy.selected_experiment._add_essence(value,my_type)
	assigned_experiment = alchemy.selected_experiment
	assigned_experiment._sort_experiment()
	
	
func _check_if_locked():
	if alchemy.debug_research_locking_disabled:
		return false
	if(in_tableau && alchemy._check_labatory_stability() == false):
		return true 
	if(in_upcoming):
		return true
	return false


func _get_drag_data(drag_position):
	if  _check_if_locked():
		return null
	#var preview = TextureRect.new()
	#preview.texture = load(value_iconpath)
	#preview.scale = Vector2(0.75,0.75)
	#preview.modulate = modulate
	#preview.position = drag_position
	#Centered preview work around 
	#Thanks to u/kleonc @ https://www.reddit.com/r/godot/comments/j0o11y/how_can_i_change_the_position_of_the_drag_preview/g6tubo4/
	#var c = Control.new()
	#c.add_child(preview)
	#preview.global_position = drag_position
	#set_drag_preview(c)
	return self
	



