extends ColorRect


@export var my_victory_letter:String
# Called when the node enters the scene tree for the first time.
func _ready():
	var my_callable = Callable(self,"_on_game_won")
	alchemy.game_won.connect(my_callable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_won():
	get_child(0).text = my_victory_letter
