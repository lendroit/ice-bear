extends Area2D

class_name Glaire

var velocity := Vector2.ZERO
const SPIT_DRAG_COEFF := 2.0

func custom_init(shooter, muzzle, orientation: int):
	self.position = muzzle.global_position
	self.velocity = shooter.velocity
	self.velocity.x += orientation * PlayerParameters.PLAYER_SPIT_VELOCITY
	self.gravity = EngineParameters.GRAVITY
	pass

func _physics_process(delta):
	velocity.y += EngineParameters.GRAVITY / SPIT_DRAG_COEFF * delta
	position += velocity * delta
	rotation = velocity.angle()

func _disappear():
	queue_free()

func _on_Glaire_body_entered(_body):
	_disappear()

func _on_Glaire_area_entered(area):
	_disappear()
