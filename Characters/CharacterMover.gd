extends Node3D

signal moved(old_position: Vector3, new_position: Vector3)

@export_group("Gravity")
@export var jump_force = 7.0
@export var gravity = 30.0

@export_group("Speed")
@export var walking_speed = 5.0
@export var sprinting_speed = 7.0
@export var crouching_speed = 2.0
@export var push_force = 3

enum MoveState {
	WALKING=1,
	SPRINTING=2,
	CROUCHING=3
}

var parent_char : CharacterBody3D
var move_vec : Vector3
var current_speed : float
var move_state : int

func _ready()->void:
	parent_char = get_parent()
	move_state = MoveState.WALKING

func set_move_vec(new_move_dir: Vector3)->void:
	move_vec = new_move_dir

func set_move_state(new_move_state: int)->void:
	move_state = new_move_state

func jump()->void:
	if parent_char.is_on_floor():
		parent_char.velocity.y = jump_force

func _physics_process(delta)->void:
	if move_state == MoveState.SPRINTING:
		current_speed = sprinting_speed
	elif move_state == MoveState.CROUCHING:
		current_speed = crouching_speed
	else:
		current_speed = walking_speed
	
	if parent_char.velocity.y > 0.0 and parent_char.is_on_ceiling():
		parent_char.velocity.y = 0.0
	if not parent_char.is_on_floor():
		parent_char.velocity.y -= gravity * delta
	
	if move_vec:
		parent_char.velocity.x = move_vec.x * current_speed
		parent_char.velocity.z = move_vec.z * current_speed
	else:
		parent_char.velocity.x = move_toward(parent_char.velocity.x, 0, current_speed)
		parent_char.velocity.z = move_toward(parent_char.velocity.z, 0, current_speed)
		
	parent_char.move_and_slide()
	
