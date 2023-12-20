extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var my_call = Callable(self,"_on_meta_counters_updated")
	alchemy.meta_counters_updated.connect(my_call)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_meta_counters_updated():
	
	var es_count = alchemy.active_essence_count
	if es_count >= alchemy.forced_meta_threshold:
		text = "META ACTIVE"
	else:
		get_child(1).value = es_count
		text = "META INACTIVE"
	get_child(0).text = str(es_count) + "/" +str(alchemy.forced_meta_threshold)+ " active tiles"
	
