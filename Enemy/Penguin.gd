extends "res://Enemy/GenericEnemy.gd"

func _ready():
	gravity_sensible = true
	possible_timer_Durations = [0.5, 1, 1.5, 2]
	possible_states_after_idle = [WALK, NEW_DIRECTION]
	possible_states_after_walk = [IDLE]
	possible_states_after_new_direction = [WALK]

func _on_LeftCliffDetector_body_exited(body):
	state = NEW_DIRECTION

func _on_RightCliffDetector_body_exited(body):
	state = NEW_DIRECTION
