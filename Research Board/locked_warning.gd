extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alchemy.practice_mode:
		visible = false
	elif  alchemy.labatory_stable == false:
		visible = true
	elif alchemy.labatory_stable == true:
		visible = false
