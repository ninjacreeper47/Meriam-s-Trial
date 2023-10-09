extends Label


var warning_symbol = "⚠"
var sleep_symbol = "💤"
var  checkmark_symbol = "✅"
var hand_symbol = "🤚"

var exname = "Experiment" + str(status_num)

var type_icons_unicode = {"Star": "★", "Plant": "⬢", "Friendship":"♥", "Metal":"■", "Water": "●"}
@export var status_num:String

var associated_experiment_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_stablized():
	self.text = status_num+ ": " + checkmark_symbol +"Stable"
func _on_inactive():
	associated_experiment_active = false
	self.text = status_num+ ": " + sleep_symbol +"Inactive"
func _on_activated():
	associated_experiment_active = true

func _on_broken():
	self.text = status_num+": " + warning_symbol + "Unstable!"
