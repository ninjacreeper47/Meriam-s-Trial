class_name  TypeQluixError extends ExError


var first_type
var second_type

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(left,right):

	error_type = "Qluix:Type"
	first_type = left
	second_type = right

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	# commutative property applies
	return  right._has_type(first_type) && right._has_type(second_type)

#This also has to be manually called
func _init_graphics():
	if !is_inside_tree():
		return
	var type_iconpath = "res://Assets/%s.svg"
	type_iconpath = type_iconpath % first_type
	get_child(2).texture=  load(type_iconpath)
	type_iconpath = "res://Assets/%s.svg"
	type_iconpath = type_iconpath % second_type
	get_child(3).texture=  load(type_iconpath)

func _is_error_present_in_experiment(ex):
	return ex.type_counts[first_type] == ex.type_counts[second_type]


func _has_type(t):
	return  first_type == t || second_type == t
