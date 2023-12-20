class_name  TypeKuduError extends ExError

var dom_type

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(dom):

	error_type = "Kudu:Type"
	dom_type = dom

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	return dom_type == right.dom_type

#This also has to be manually called
func _init_graphics():
	if !is_inside_tree():
		return
	var type_iconpath = "res://Assets/%s.svg"
	type_iconpath = type_iconpath % dom_type
	get_child(2).texture=  load(type_iconpath)

func _is_error_present_in_experiment(ex):
	return ex.num_essences - ex.type_counts[dom_type] < ex.type_counts[dom_type]
