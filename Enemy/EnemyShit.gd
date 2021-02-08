extends RigidBody2D

class_name Shit

signal shit_exploded

const SPEED = 30
const ENEMY_GLAIRE_DRAG_COEFF := 2.0

onready var animation_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D

func _ready():
	contact_monitor = true
	contacts_reported = 1

func _integrate_forces(state):
	add_force(Vector2.ZERO, SPEED * Vector2.DOWN)

func _disable_shit():
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	collision_shape.set_deferred("disabled", true)

func _on_EnemyGlaire_body_entered(body):
	emit_signal("shit_exploded", self)
	_disable_shit()
	animation_player.play("Death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "Death"):
		queue_free()
