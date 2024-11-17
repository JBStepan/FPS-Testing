extends RayCast3D

@onready var label = $Label

func _physics_process(delta):
	label.text = ""
	
	if is_colliding():
		var collider = get_collider()
		
		if collider is Interactable:

			if Global.controller_connected == true:
				label.text = collider.prompt + "\n [A] \n"
			else:
				label.text = collider.prompt + "\n [E] \n"
		
			if Input.is_action_just_pressed("interact"):
				collider.interact(self)
