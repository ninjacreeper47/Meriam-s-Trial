extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Input.is_action_just_pressed("ViewUpcomming")  && position.y > -400:
		translate(Vector2.UP*100)
	if Input.is_action_just_pressed("StopLookahead") && position.y < 500 :
		translate(Vector2.DOWN*100)
