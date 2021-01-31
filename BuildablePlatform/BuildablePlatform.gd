extends StaticBody2D

export (float) var building_animation_time = 0.6

onready var animation_player = $AnimationPlayer
onready var build_animation_timer = $BuildAnimationTimer
onready var body = $Body

var builded := false
var building := false

func _ready():
	unbuilded()

func reset_build_animation_timer():
	build_animation_timer.set_wait_time(building_animation_time)
	build_animation_timer.start()

func unbuilded():
	if(!builded && !building):
		building = false
		builded = false
		animation_player.play("Unbuilded")

func build():
	if(!builded && !building):
		building = true
		builded = false
		animation_player.play("Building")
		reset_build_animation_timer()

func end_build():
	if(!builded && building):
		building = false
		builded = true
		body.disabled = !builded
		animation_player.play("Builded")

func _on_BuildAnimationTimer_timeout():
	end_build()

func _on_BeaverDetector_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	build()
