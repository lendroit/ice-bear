extends Area2D

var velocity = Vector2(550, 0)

var speed = 250

#func _physics_process(delta):
#	position += transform.x * speed * delta


	
func _process(delta):
	velocity.y += EngineParameters.GRAVITY/2 * delta
	position += velocity * delta
	rotation = velocity.angle()

func _on_Glaire_body_entered(body):
	queue_free()
