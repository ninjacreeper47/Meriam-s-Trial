class_name LetterKuduError extends ExError

var dom_letter

#intentionially not using _init() because that won't play nice with parameters and node instantiation. YOU HAVE TO MANUALLY CALL THIS
func _initialize(dom):

	error_type = "Kudu:Letter"
	dom_letter = dom

func _is_same(right:ExError):
	if right.error_type != error_type:
		return false
	return dom_letter == right.dom_letter

func _is_error_present_in_experiment(ex):
	return ex.num_essences - ex.value_counts[dom_letter] < ex.value_counts[dom_letter]


func _init_graphics():
	get_child(2).text = dom_letter
