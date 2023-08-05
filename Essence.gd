extends TextureButton

#Essense Attributes

var value = _pickValue()
var my_type = _pickType()
var value_iconpath = "res://Assets/dice-six-faces-%s.svg"

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

func _pickType():
	return  randi() % alchemy.type.size() 

func _set_type(type):
	my_type = type
	_type_visual()
func _pickValue():
	return randi() % 6 + 1
	
func _generateIcon():
	_type_visual()
	value_iconpath = value_iconpath % value
	self.texture_normal = load(value_iconpath)

func _type_visual():
	match (my_type):
		alchemy.type.Metal:
			self.modulate = Color.SLATE_GRAY
		alchemy.type.Plant:
			self.modulate = Color.DARK_GREEN
		alchemy.type.Star:
			self.modulate = Color.YELLOW
		alchemy.type.Water:
			self.modulate = Color.BLUE
		alchemy.type.Friendship:
			self.modulate = Color.RED
		_:
			print("Invalid Type in _type_visual()")

func _on_pressed():
	if _check_if_locked():
		return
	if assigned_experiment == alchemy.selected_experiment:
		return  
	if(alchemy.selected_experiment._is_full() == true):
		return 
	if(assigned_experiment != null):
		assigned_experiment._remove_essence(value,my_type)
	if(in_tableau):
		taken_from_tableau.emit(my_col)
		in_tableau = false
	alchemy.selected_experiment._add_essence(value,my_type)
	assigned_experiment = alchemy.selected_experiment
	reparent(alchemy.selected_experiment)
	alchemy.alchemic_state_changed.emit()
	
	
func _check_if_locked():
	if(in_tableau && alchemy._check_labatory_stability() == false):
		return true 
	if(in_upcoming):
		return true
	return false


func _get_drag_data(drag_position):
	if  _check_if_locked():
		return null
	var preview = TextureRect.new()
	preview.texture = load(value_iconpath)
	preview.scale = Vector2(0.75,0.75)
	preview.modulate = modulate
	preview.position = drag_position
	#Centered preview work around 
	#Thanks to u/kleonc @ https://www.reddit.com/r/godot/comments/j0o11y/how_can_i_change_the_position_of_the_drag_preview/g6tubo4/
	var c = Control.new()
	c.add_child(preview)
	preview.global_position = drag_position
	set_drag_preview(c)
	return self
	



