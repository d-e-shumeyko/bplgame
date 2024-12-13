extends AudioStreamPlayer3D


@export var ostAudio : AudioStreamPlayer

@onready var songs = [
	"res://audio/music/goat/ftw full02.wav",
	"res://audio/music/goat/hellova way03.wav"
] 

func _ready() -> void:

	ostAudio.stream_paused = false

	stream = load(rand_song())
	play()

func _process(delta: float) -> void:
	if playing == false:
		stream = load(rand_song())
	

func rand_song():
	var randSong = songs [randi() % songs.size()]
	return randSong


func _on_area_3d_body_entered(body: Node3D) -> void:
	ostAudio.stream_paused = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	ostAudio.stream_paused = false
