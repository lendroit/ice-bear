extends Node2D

onready var building_animation = $BuildingAnimation 

signal platform_builded

func unbuilded():
		$Unbuilded.visible = true
		$Building.visible = false
		$Builded.visible = false

func building():
		$Unbuilded.visible = false
		$Building.visible = true
		$Builded.visible = false
		building_animation.play("Building")

func builded():
		$Unbuilded.visible = false
		$Building.visible = false
		$Builded.visible = true

func _on_BuildingAnimation_animation_finished(_anim_name):
	emit_signal("platform_builded")
