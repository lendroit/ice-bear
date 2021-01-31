extends Area2D

var velocity := Vector2.ZERO
const SPIT_DRAG_COEFF := 2.0

func _process(delta):
	velocity.y += EngineParameters.GRAVITY / SPIT_DRAG_COEFF * delta
	position += velocity * delta
	rotation = velocity.angle()

func _on_Glaire_body_entered(_body):
	queue_free()
