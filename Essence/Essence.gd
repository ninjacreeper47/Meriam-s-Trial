extends TextureButton

#Essense Attributes
@export_enum("A","B","C","D","E","F" ) var value :String
@export_enum("Metal","Plant","Star","Water","Friendship") var my_type :String 



var in_tableau = false
var in_upcoming = false #This should be set by the upcomming essence!
var my_col:int
@onready var experiment_list = get_tree().get_nodes_in_group("Experiments") 
var assigned_experiment 

var preview_node = load("res://Essence/essence_preview.tscn")
var my_texture
var blank_placeholder = load("res://Assets/BlankSpace.png")

signal taken_from_tableau
signal taken_from_upcoming
# Called when the node enters the scene tree for the first time.
func _ready():
	_generateIcon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _check_if_locked():
		modulate = Color.DARK_GRAY
	else:
		modulate = Color.WHITE

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
	my_texture = load(type_iconpath)
	texture_normal = my_texture
	get_child(0).text = str(value)


func _on_pressed():
	if visible == false:
		return
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
	if(in_upcoming):
		taken_from_upcoming.emit(my_col,self)
		in_upcoming = false
	alchemy.selected_experiment._add_essence(value,my_type)
	assigned_experiment = alchemy.selected_experiment
	assigned_experiment._sort_experiment()
	
	
func _check_if_locked():
	if alchemy.debug_research_locking_disabled:
		return false
	if alchemy.practice_mode:
		return false
	if(in_tableau && alchemy._check_labatory_stability() == false):
		return true 
	if(in_upcoming):
		return true
	if(!alchemy.game_playing):
		return true
	return false


func _get_drag_data(drag_position):
	if  _check_if_locked():
		return null
	_hide()
	var preview = preview_node.instantiate()
	preview.set_texture(my_texture)
	preview.scale = Vector2(0.4,0.4)
	preview.my_parent = self
	preview.get_child(0).text = value  #the first child should be the text label!
	set_drag_preview(preview)
	return self
	

#can't simply make the node no longer visible, because then containers reorganize
#these functions are a workaround for that :)
func _hide():
	texture_normal = blank_placeholder
	get_child(0).visible = false
	
func _unhide():
	texture_normal = my_texture
	get_child(0).visible = true
