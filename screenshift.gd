extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ZoomIn"):
		zoom += Vector2(0.1,0.1)
	if Input.is_action_just_pressed("ZoomOut"):
		zoom -= Vector2(0.1,0.1)
	if Input.is_action_just_pressed("ResetZoom"):
		zoom = Vector2(1,1)
