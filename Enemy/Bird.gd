extends "res://Enemy/GenericEnemy.gd"

onready var shoot_timer = $ShootTimer

var possible_shoot_timer_durations = [0.25, 0.5, 0.75, 1]

func upd_shoot_timer_duration():
	shoot_timer.set_wait_time(choose(possible_shoot_timer_durations))

func reset_shoot_timer():
	upd_shoot_timer_duration()
	shoot_timer.start()

func _ready():
	reset_shoot_timer()

func shoot():
	reset_shoot_timer()
	print("Pew Pew Pew !")

func _on_ShootTimer_timeout():
	shoot()
