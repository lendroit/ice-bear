extends StaticBody2D

onready var body = $Body
onready var logs = $Logs

var builded := false
var building := false

func _ready():
	unbuilded()
	var _useless = $Logs.connect("platform_builded", self, "end_build")

func unbuilded():
	if(!builded && !building):
		building = false
		builded = false
		body.disabled = true
		logs.unbuilded()

func build():
	if(!builded && !building):
		building = true
		builded = false
		logs.building()

func end_build():
	if(!builded && building):
		building = false
		builded = true
		body.disabled = false
		logs.builded()

func _on_BeaverDetector_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	build()
