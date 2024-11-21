extends HSlider


@export var bus_name : String
var  bus_index: int
var volume : float

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	volume = value
	

	


func _on_drag_ended(_value_changed: bool) -> void:
		AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
