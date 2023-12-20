class_name  LetterQluixError extends ExError


var first_letter
var second_letter

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(left,right):

	error_type = "Qluix:Letter"
	first_letter = left
	second_letter = right

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	# commutative property applies
	return  right._has_letter(first_letter) && right._has_letter(second_letter)

#This also has to be manually called
func _init_graphics():
	if !is_inside_tree():
		return
	get_child(2).text = first_letter
	get_child(3).text = second_letter

func _is_error_present_in_experiment(ex):
	return ex.value_counts[first_letter] == ex.value_counts[second_letter]


func _has_letter(l):
	return  first_letter == l || second_letter == l
