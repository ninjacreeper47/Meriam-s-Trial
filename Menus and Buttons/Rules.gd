extends Tree

var godoticon = load("res://icon.svg")

var qluixex1 = load("res://Assets/Law Examples/QluixEx1.svg")
var qluixex2 = load("res://Assets/Law Examples/QluixEx2.svg")
var kuduex1 = load("res://Assets/Law Examples/KuduEx1.svg")
var kuduex2 = load("res://Assets/Law Examples/KuduEx2.svg")

var root = create_item()
var goal = create_item(root)
var experiments = create_item(root)
var research = create_item(root)
var storage = create_item(root)
var alchemical_laws = create_item(root)
var types_of_sets
# Called when the node enters the scene tree for the first time.
func _ready():
	_goal()
	_experiments()
	_research()
	_storage()
	_alchemical_laws()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _alchemical_laws():
	alchemical_laws.set_text(0,"Alchemical Laws")
	alchemical_laws.set_tooltip_text(0," ")
	_first_law()
	_second_law()
	if (!alchemy.student_game):
		_elements_elaboration()
		
func _first_law():
	var law1 = create_item(alchemical_laws)
	law1.set_text(0,"Anti-equality Law")
	law1.set_tooltip_text(0," ")
	var explanation = create_item(law1)
	explanation.set_text(0,"A set can't have the same count for different features")
	explanation.set_tooltip_text(0," ")
	var examples = create_item(law1)
	examples.set_text(0,"example violations")
	examples.set_tooltip_text(0," ")
	var example1 = create_item(examples)
	example1.set_icon(0,qluixex1)
	var example2 = create_item(examples)
	example2.set_icon(0,qluixex2)
func _second_law():
	var law2 = create_item(alchemical_laws)
	law2.set_text(0,"Anti-Dominance Law")
	law2.set_tooltip_text(0," ")
	var explanation = create_item(law2)
	explanation.set_text(0,"A  set can't have more than 50% of one feature ")
	explanation.set_tooltip_text(0," ")
	var examples = create_item(law2)
	examples.set_text(0,"example violations")
	examples.set_tooltip_text(0," ")
	var example1 = create_item(examples)
	example1.set_icon(0,kuduex1)
	var example2 = create_item(examples)
	example2.set_icon(0,kuduex2)
func _elements_elaboration():
	types_of_sets = create_item(alchemical_laws)
	types_of_sets.set_text(0,"Types of sets")
	types_of_sets.set_tooltip_text(0," ")
	var ee = create_item(types_of_sets)
	ee.set_text(0,"Each tile has both a shape and a letter 
	Shapes and letters are distinct sets for alchemical laws!
	An experiment is only stable if
	its set of shapes  follows both laws
	AND its set of letters also follows both laws")
	ee.set_tooltip_text(0," ")
	_meta_constraints()
func _meta_constraints():
	var meta = create_item(types_of_sets)
	meta.set_text(0,"Meta Constraints")
	meta.set_tooltip_text(0," ")
	var explanation = create_item(meta)
	explanation.set_text(0,"Tiles are considered *active* if they are in an experiment
	If you have at least 20 active tiles, then meta constraints apply
	Meta expands the scope of alchemical laws
	--Experiments can't have the same number of tiles 
	--No experiment can account for more than 50% of active tiles
	
	Experiments which violate meta laws become unstable")
	explanation.set_tooltip_text(0, " ")
func _goal():
	goal.set_text(0,"Goal")
	goal.set_tooltip_text(0," ")
	var goal_descriptoin = create_item(goal)
	goal_descriptoin.set_text(0,"Place every tile into an experiment AND have no unstable experiments")
	goal_descriptoin.set_tooltip_text(0," ")
func _research():
	research.set_text(0,"Research")
	research.set_tooltip_text(0," ")
	var research_description = create_item(research)
	research_description.set_text(0,"Tiles must be taken from the bottom row of research
	After taking a tile, all tiles in that column will fall down 1 space
	Tiles can never be placed back into research
	
	If there are any unstable experiments, all tiles in research are locked")
	research_description.set_tooltip_text(0," ")
func _experiments():
	experiments.set_text(0,"Experiments")
	var experiments_description = create_item(experiments)
	experiments_description.set_text(0,"Tiles can be freely moved into or out of experiments
	Experiments are sets that are subject to *alchemical laws*
	If an experiment follows all laws, then it is considered stable
	If an experiments breaks any laws, then it is considered unstable")
func _storage():
	storage.set_text(0,"Storage")
	storage.set_tooltip_text(0," ")
	var storage_description = create_item(storage)
	storage_description.set_text(0,"Tiles can be freely moved into or out of storage
	Tiles in storage do not interact with alchemical laws
	Storage has a capacity of 9 tiles")
