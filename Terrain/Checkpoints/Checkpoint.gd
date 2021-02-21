tool
extends Node2D

signal checkpoint_activated

export (bool) var is_active = false setget _set_is_active

onready var _flag = $Flag
onready var spawn_position = $SpawnPosition

func _ready():
	deactivate()

func _handle_sprite():
	if !_flag:
		return

	_flag.set_is_active(is_active)


func _set_is_active(new_is_active):
	is_active = new_is_active
	_handle_sprite()


func activate():
	if is_active:
		return

	var checkpoints = get_tree().get_nodes_in_group("checkpoint")
	for checkpoint in checkpoints:
		checkpoint.deactivate()

	is_active = true
	_handle_sprite()
	emit_signal("checkpoint_activated", self)


func deactivate():
	is_active = false
	_handle_sprite()


func _on_PlayerCollider_area_entered(_area):
	activate()
