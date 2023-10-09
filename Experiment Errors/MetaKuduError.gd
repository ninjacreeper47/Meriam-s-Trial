class_name  MetaKuduError extends ExError

var dom_ex

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(dom):

	error_type = "Kudu:Meta"
	dom_ex= dom

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	return dom_ex== right.dom_ex

func _is_error_present_in_experiment(ex):
	if alchemy.active_essence_count < alchemy.forced_meta_threshold:
		return false
	if !ex.active:
		return false
	return alchemy.active_essence_count - ex.num_essences < ex.num_essences


func _init_graphics():
	get_child(2).text = "Ex["+ str(dom_ex) +"]"
