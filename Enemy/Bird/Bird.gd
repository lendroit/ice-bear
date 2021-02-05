extends "res://Enemy/GenericEnemy.gd"

class_name Bird

signal bird_shot

onready var shoot_timer = $ShootTimer

var possible_shoot_timer_durations = [0.7, 0.85, 1]

var Glaire = preload("res://Enemy/EnemyGlaire.tscn")
export var spit_velocity = 650

func upd_shoot_timer_duration():
	shoot_timer.set_wait_time(Utils.pick_random(possible_shoot_timer_durations))

func reset_shoot_timer():
	upd_shoot_timer_duration()
	shoot_timer.start()

func _ready():
	reset_shoot_timer()

func shoot():
	var new_shit = Glaire.instance()
	new_shit.position = self.position
	emit_signal("bird_shot", new_shit)

func _on_ShootTimer_timeout():
	reset_shoot_timer()
	shoot()
