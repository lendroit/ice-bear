extends "res://Enemy/GenericEnemy.gd"

class_name Bird

signal bird_shot

@onready var shoot_timer = $ShootTimer

var possible_shoot_timer_durations = [0.7, 0.85, 1]

var Shit = preload("res://Enemy/EnemyShit.tscn")
@export var spit_velocity = 650

func upd_shoot_timer_duration():
	shoot_timer.set_wait_time(Utils.pick_random(possible_shoot_timer_durations))

func reset_shoot_timer():
	upd_shoot_timer_duration()
	shoot_timer.start()

func _ready():
	reset_shoot_timer()

func shoot():
	if (!is_visible_by_player):
		# Do not shit if player is not around
		# it creates buggy particles
		return

	$ShootAnimationPlayer.play("StartShitting")
	var new_shit = Shit.instantiate()
	new_shit.position = self.position
	emit_signal("bird_shot", new_shit)

func _on_ShootTimer_timeout():
	reset_shoot_timer()
	shoot()
