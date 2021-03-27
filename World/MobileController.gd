extends Control

#VISIBILITY_ALWAYS = Always visible.
#VISIBILITY_TOUCHSCREEN_ONLY = Visible on touch screens only.
enum VisibilityMode {ALWAYS , TOUCHSCREEN_ONLY }

export(VisibilityMode) var visibility_mode := VisibilityMode.ALWAYS

func _ready() -> void:
	if not OS.has_touchscreen_ui_hint() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
		hide()
