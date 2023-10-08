extends TextureRect

@export var ByTypeIndicatorPos :Control
@export var ByLetterIndicatorPos:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sort_by_type_pressed():
	reparent(ByTypeIndicatorPos,false)


func _on_sort_by_letter_pressed():
	reparent(ByLetterIndicatorPos,false)
