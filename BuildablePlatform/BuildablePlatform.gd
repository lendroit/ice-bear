extends StaticBody2D

onready var body = $Body
onready var logs = $Logs

var is_builded = false

func _ready():
	unbuilded()
	var _useless = $Logs.connect("platform_builded", self, "end_build")

func unbuilded():
	body.disabled = true
	logs.unbuilded()

func build():
	if is_builded:
		return

	logs.building()

func end_build():
	body.disabled = false
	is_builded = true
	logs.builded()

func _on_BeaverDetector_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	build()
