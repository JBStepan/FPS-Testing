extends CharacterBody3D
class_name Player

signal player_moved(old_pos : Vector3, new_pos : Vector3)

@onready var head = $Head
@onready var char_mover = $CharacterMover

@export_group("Game Variables")
@export var stamina = 20

@export_group("Look")
@export var mouse_sens_h = 0.25
@export var mouse_sens_v = 0.25

@export var controller_sens_h = 4
@export var controller_sens_v = 4
@export_group("Movement")
@export var move_lerp_speed = 10.0

var move_vec = Vector3.ZERO

func _ready()->void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event)->void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens_h))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens_v))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
	if event is InputEventJoypadMotion:
		pass

func _process(delta)->void:
	var old_pos = global_position
	
	char_mover.set_move_state(1)
	
	if InputEventJoypadMotion:
		var axis_vector = Vector2.ZERO
		axis_vector.x  = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
		axis_vector.y  = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		
		rotate_y(deg_to_rad(-axis_vector.x * controller_sens_h))
		head.rotate_x(deg_to_rad(-axis_vector.y * controller_sens_v))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
	
	if Input.is_action_just_pressed("debug_quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("debug_togglemouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if Input.is_action_just_pressed("jump"):
		char_mover.jump()
	
	if Input.is_action_pressed("sprint"):
		char_mover.set_move_state(2)
	elif Input.is_action_pressed("crouch"):
		char_mover.set_move_state(3)
	
	var input_vec = Input.get_vector("left", "right", "forward", "backward").normalized()
	move_vec = lerp(move_vec, (transform.basis * Vector3(input_vec.x, 0, input_vec.y)), delta*move_lerp_speed)

	char_mover.set_move_vec(move_vec)
	emit_signal("player_moved", old_pos, global_position)
