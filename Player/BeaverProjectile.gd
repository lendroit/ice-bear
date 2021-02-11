extends Area2D

var velocity := Vector2.ZERO
const BEAVER_DRAG_COEFF := 1.3

func custom_init(shooter, muzzle, orientation: int):
	self.position = muzzle.global_position
	self.velocity = shooter.velocity
	self.velocity.x += orientation * PlayerParameters.PLAYER_SPIT_VELOCITY
	self.gravity = EngineParameters.GRAVITY


func _physics_process(delta):
	velocity.y += EngineParameters.GRAVITY / BEAVER_DRAG_COEFF * delta
	position += velocity * delta
	rotation = velocity.angle()

func _on_BeaverProjectile_body_entered(_body):
	queue_free()
