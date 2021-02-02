extends Node2D

onready var building_animation = $BuildingAnimation 

signal platform_builded

func unbuild():
	$Unbuilded.visible = true
	$Logs.visible = false

func build():
	$Unbuilded.visible = false
	$Logs.visible = true
	building_animation.play("Build")

func _on_BuildingAnimation_animation_finished(_anim_name):
	emit_signal("platform_builded")
