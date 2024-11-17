extends Interactable

@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func _on_interacted(body):
	audio_stream_player_3d.play()
