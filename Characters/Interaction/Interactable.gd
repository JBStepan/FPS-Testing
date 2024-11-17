extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt = "Interact"

func interact(body):
	emit_signal("interacted", body)
