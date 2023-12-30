extends TextureRect

@export var position1 :Control
@export var position2 :Control
@export var position3: Control
@export var position4: Control
@export var position0: Control

var ex_x_offset = 160
var ex_y_offset = 400
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("SelectEx1"):
		alchemy.selected_experiment = alchemy.experiment_nodes[1]
		position = position1.position
		position.x += ex_x_offset
		position.y += ex_y_offset
		visible = true
	if Input.is_action_just_pressed("SelectEx2"):
		alchemy.selected_experiment = alchemy.experiment_nodes[2]
		position = position2.position
		position.x += ex_x_offset
		position.y += ex_y_offset
		visible = true
	if Input.is_action_just_pressed("SelectEx3"):
		alchemy.selected_experiment = alchemy.experiment_nodes[3]
		position = position3.position
		position.x += ex_x_offset
		position.y += ex_y_offset
		visible = true
	if Input.is_action_just_pressed("SelectEx4"):
		alchemy.selected_experiment = alchemy.experiment_nodes[4]
		position = position4.position
		position.x += ex_x_offset
		position.y += ex_y_offset
		visible = true 
	if Input.is_action_just_pressed("storage"):
		alchemy. selected_experiment = alchemy.experiment_nodes[0]
		position = position0.position
		position.x += 175
		position.y += 315
		visible = true
