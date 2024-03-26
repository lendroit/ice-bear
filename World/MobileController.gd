extends Control

#VISIBILITY_ALWAYS = Always visible.
#VISIBILITY_TOUCHSCREEN_ONLY = Visible on touch screens only.
enum VisibilityMode {ALWAYS , TOUCHSCREEN_ONLY }

@export var visibility_mode := VisibilityMode.ALWAYS

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
		hide()
