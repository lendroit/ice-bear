extends StaticBody2D

@onready var body = $Body
@onready var logs = $Logs

var is_builded = false

func _ready():
	unbuild()
	var _useless = $Logs.connect("platform_builded", Callable(self, "end_build"))

func unbuild():
	body.disabled = true
	logs.unbuild()

func build():
	if is_builded:
		return

	logs.build()

func end_build():
	body.disabled = false
	is_builded = true

func _on_BeaverDetector_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	build()
