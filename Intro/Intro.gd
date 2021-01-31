extends Control

var World = preload("res://ActualWorld.tscn")

func _ready():
	$DialogIterator.connect("end", self, "start_game")
	$DialogIterator.start()

func start_game():
	get_tree().change_scene_to(World)

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		get_tree().change_scene_to(World)
#		return
#	if event is InputEventScreenTouch:
#		get_tree().change_scene_to(World)
#		return
