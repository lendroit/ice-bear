extends "res://Enemy/GenericEnemy.gd"

onready var shoot_timer = $ShootTimer

var possible_shoot_timer_durations = [0.25, 0.5, 0.75, 1]

var Glaire = preload("res://Enemy/EnemyGlaire.tscn")
export var spit_velocity = 650

func upd_shoot_timer_duration():
	shoot_timer.set_wait_time(choose(possible_shoot_timer_durations))

func reset_shoot_timer():
	upd_shoot_timer_duration()
	shoot_timer.start()

func _ready():
	reset_shoot_timer()

func shoot():
	var b = Glaire.instance()
	owner.add_child(b)
	b.position = self.position
	b.velocity = self.velocity
	b.velocity.x = 0
	b.velocity.y += spit_velocity
	b.gravity = EngineParameters.GRAVITY

func _on_ShootTimer_timeout():
	reset_shoot_timer()
	shoot()
