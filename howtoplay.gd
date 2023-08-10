extends TextureRect

var slide_num = 1
var instructions_path = "res://Assets/How to Play/Instructions/Slide%s.png"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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

func _next_page():
	if slide_num < 5:
			slide_num += 1
	var slide_path = instructions_path % slide_num
	texture = load(slide_path)
