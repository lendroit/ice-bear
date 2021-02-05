extends RigidBody2D

class_name Shit

signal shit_exploded

const SPEED = 30
const ENEMY_GLAIRE_DRAG_COEFF := 2.0

func _ready():
	contact_monitor = true
	contacts_reported = 1

func _integrate_forces(state):
	add_force(Vector2.ZERO, SPEED * Vector2.DOWN)

func _on_EnemyGlaire_body_entered(body):
	emit_signal("shit_exploded", self)
	queue_free()
