class_name  MetaQluixError extends ExError

var first_ex
var second_ex

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(left,right):

	error_type = "Qluix:Meta"
	first_ex = left
	second_ex = right

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	# commutative property applies
	return  right._has_ex(first_ex) && right._has_ex(second_ex)

func _is_error_present_in_experiment(ex):
	if alchemy.active_essence_count < alchemy.forced_meta_threshold:
		return false
	return alchemy.essence_counts[first_ex] == alchemy.essence_counts[second_ex]


func _init_graphics():
	get_child(2).text = "Ex["+ str(first_ex) +"]"
	get_child(3).text = "Ex["+ str(second_ex) +"]"

func _has_ex(e):
	return  first_ex == e || second_ex == e
