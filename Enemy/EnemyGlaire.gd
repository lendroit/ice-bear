extends Area2D

var velocity := Vector2.ZERO
const ENEMY_GLAIRE_DRAG_COEFF := 2.0

func _process(delta):
	velocity.y += EngineParameters.GRAVITY / ENEMY_GLAIRE_DRAG_COEFF * delta
	position += velocity * delta
	rotation = velocity.angle()

func _on_Glaire_body_entered(_body):
	queue_free()
