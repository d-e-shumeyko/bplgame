extends BoxContainer

var cans = GlobalVariables.canNumber
var cake = GlobalVariables.cakeTaken
var toob = GlobalVariables.toobTaken
var state = 0
var cansActual = 0
var cakeNot = "Not Found"
var cakeTaken = "In Possession"
var toobNot = "Not Found"
var toobTaken = "In Possession"
@export var label : Label

func _ready() -> void:
	if get_tree().current_scene.name == "Cellar":
		state = 1
		label.text =  "Cans Collected: " + str(cansActual) + "/3"
	if get_tree().current_scene.name == "Forest":
		state = 2
		label.text = "Cake " + cakeNot
	if get_tree().current_scene.name == "locationRedacted":
		state = 3
		label.text = "Toob " + toobNot

	print(state)

func _process(delta: float) -> void:
	cans = GlobalVariables.canNumber
	if state == 1:
		if cansActual != cans:
			cansUpdate()
	elif state == 2:
		if cake != GlobalVariables.cakeTaken:
			cakeUpdate()
	elif state == 3:
		if toob != GlobalVariables.toobTaken:
			toobUpdate()

	
func cansUpdate():
	cansActual = GlobalVariables.canNumber
	label.text =  "Cans Collected: " + str(cansActual) + "/3"

func cakeUpdate():
	label.text = "Cake " + cakeTaken

func toobUpdate():
	label.text = "Toob " + toobTaken


#func _on_cake_visibility_changed() -> void:
	#cakeNot = cakeTaken
