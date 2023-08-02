extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var my_call = Callable(self,"_on_meta_counters_updated")
	alchemy.meta_counters_updated.connect(my_call)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_meta_counters_updated():
	
	var ex_count = alchemy.active_experiments
	var es_count = alchemy._count_active_essences()
	if ex_count >= 3 || es_count >= 20:
		text = "META ACTIVE"
	else:
		text = "META INACTIVE"
	get_child(0).text = str(ex_count) + "/3 active experiments"
	get_child(1).text = str(es_count) + "/20 active essence"
