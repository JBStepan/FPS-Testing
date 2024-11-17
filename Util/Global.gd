extends Node

var player : Player

var is_debug = true
var controller_connected

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(delta):
	if Input.get_connected_joypads().size() > 0:
		controller_connected = true
	else:
		controller_connected = false
