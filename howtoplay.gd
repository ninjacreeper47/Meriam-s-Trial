extends TextureRect

var slide_num = 1
var instructions_path = "res://Assets/How to Play/Instructions/Slide%s.PNG"

@export var slide_count:int

@export var prev_button :Button
@export var next_button: Button
# Called when the node enters the scene tree for the first time.
func _ready():
	if alchemy.new_player_entering:
		_open()
	prev_button.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		_prev_page()
	if Input.is_action_just_pressed("ui_right"):
		_next_page()

func _prev_page():
	if slide_num > 1:
		slide_num -= 1
		var slide_path = instructions_path % slide_num
		texture = load(slide_path)
		next_button.visible = true
	if slide_num == 1:
		prev_button.visible = false

func _next_page():
	if slide_num < slide_count:
		slide_num += 1
		var slide_path = instructions_path % slide_num
		texture = load(slide_path)
		prev_button.visible = true
	if slide_num == slide_count:
		next_button.visible = false

func _close():
	get_parent().visible = false

func _open():
	get_parent().visible = true
