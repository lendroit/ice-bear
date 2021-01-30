extends Control

var World = preload("res://World.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to(World)
		return
	if event is InputEventScreenTouch:
		get_tree().change_scene_to(World)
		return
