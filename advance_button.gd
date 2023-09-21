extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alchemy.labatory_stable && alchemy.active_experiments == 2:
		visible = true
