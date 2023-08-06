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
	var metacall = Callable(self,"_on_meta_breached")
	alchemy.meta_breached.connect(metacall)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_kudu_breached(dominant):
	if type_icons_unicode.has(dominant):
		self.text = status_num+ ": " + warning_symbol + type_icons_unicode[dominant] +"dominant"
	else:
		self.text = status_num+ ": " + warning_symbol + dominant +" dominant"
func _on_qluix_breached(equal1,equal2):
	if type_icons_unicode.has(equal1) && type_icons_unicode.has(equal2):
		self.text = status_num+ ": " + warning_symbol + type_icons_unicode[equal1] + "=" + type_icons_unicode[equal2]
	else:
		self.text = status_num+ ": " + warning_symbol + equal1 + "=" +equal2
func _on_stablized():
	self.text = status_num+ ": " + checkmark_symbol +"Stable"
func _on_inactive():
	associated_experiment_active = false
	self.text = status_num+ ": " + sleep_symbol +"Inactive"
func _on_meta_breached():
	if(associated_experiment_active == true):
		self.text = status_num+ ": " + warning_symbol +"Meta"
func _on_activated():
	associated_experiment_active = true
