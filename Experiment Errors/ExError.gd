#This is intended as an abstract class,  instances should be specific errors that extend this and implement each function
#Initialization constructor should be done in the code that instantiates it
class_name ExError extends Control
var error_type
#Make sure to use this function instead of ==.   ExErrors have commutativity.  An error A = B is the same as an error B = A
func _is_same(right:ExError):
	assert("ExError base class is_same shouldn't be running oomfie")
	return error_type == right.error_type  #this logic isn't complete, true equality checks are implented in child classes

func _is_error_present_in_experiment(ex):
	assert("ExError base class _is_error_present_in_experiment shouldn't be running oomfie")
	return false

