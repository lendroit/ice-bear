tool
extends Node2D

export (bool) var is_active = false setget _set_is_active

onready var flag = $Flag

func _ready():
	deactivate()

func _handle_sprite():
	if !flag:
		return

	flag.set_is_active(is_active)


func _set_is_active(new_is_active):
	is_active = new_is_active
	_handle_sprite()


func activate():
	is_active = true
	_handle_sprite()


func deactivate():
	is_active = false
	_handle_sprite()
