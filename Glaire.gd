extends Area2D

var velocity = Vector2(350, 0)

var speed = 250

#func _physics_process(delta):
#	position += transform.x * speed * delta


	
func _process(delta):
	velocity.y += EngineParameters.GRAVITY * delta
	position += velocity * delta
	rotation = velocity.angle()

func _on_BallisticBullet_body_entered(body):
	queue_free()