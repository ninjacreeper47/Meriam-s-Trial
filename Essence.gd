extends TextureButton

#Essense Attributes

var value = _pickValue()
var my_type = _pickType()
var value_iconpath = "res://Assets/dice-six-faces-%s.svg"

@onready var experiment_list = get_tree().get_nodes_in_group("Experiments") 
var assigned_experiment 
#Selection Varibles

# Called when the node enters the scene tree for the first time.
func _ready():
	_generateIcon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pickType():
	return  randi() % alchemy.type.size() 
func _pickValue():
	return randi() % 6 + 1
	
func _generateIcon():
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
			print("Invalid Type in _generateIcon()")
	value_iconpath = value_iconpath % value
	self.texture_normal = load(value_iconpath)



func _on_pressed():
	if assigned_experiment == alchemy.selected_experiment:
		return
	if(assigned_experiment != null):
		assigned_experiment._remove_essence(value,my_type)
	alchemy.selected_experiment._add_essence(value,my_type)
	assigned_experiment = alchemy.selected_experiment
	reparent(alchemy.selected_experiment)
	
