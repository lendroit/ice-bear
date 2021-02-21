tool
extends Node2D

export (bool) var is_active = false setget _set_is_active

onready var sprite_container = $SpriteContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	desactivate()

func _handle_sprite():
	if(sprite_container):
		sprite_container.my_set_sprite(is_active)

func _set_is_active(new_is_active):
	is_active = new_is_active
	_handle_sprite()

func activate():
	is_active = true
	_handle_sprite()
	
func desactivate():
	is_active = false
	_handle_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
