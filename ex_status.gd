extends Label


var exname = "Experiment" + str(status_num)

@export var status_icon : TextureRect

@export var status_num:String

@export var ZZZ_icon:Texture2D
@export var checkmark_icon:Texture2D
@export var warning_icon:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_broken():
	self.text = status_num+": " + "Unstable"
	status_icon.texture = warning_icon

func _on_stabilized():
	self.text = status_num+ ": "  +"Stable"
	status_icon.texture = checkmark_icon
