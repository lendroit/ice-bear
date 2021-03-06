extends "res://Enemy/GenericEnemy.gd"

func _init():
	gravity_sensible = true
	possible_walking_timer_durations = [0.5, 1, 1.5, 2]
	possible_states_after_idle = [WALK]
	possible_states_after_walk = [IDLE]
	possible_states_after_new_direction = [WALK]

func _on_LeftCliffDetector_body_exited(_body):
	state = NEW_DIRECTION

func _on_RightCliffDetector_body_exited(_body):
	state = NEW_DIRECTION
