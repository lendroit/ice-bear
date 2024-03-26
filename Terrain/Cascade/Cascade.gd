@tool
extends Node2D

@export (float) var size = 3: set = _set_size

@onready var cascade_sprite = $CascadeSprite
@onready var end_of_cascade = $CascadeSprite/EndOfCascade
@onready var particles = $GPUParticles2D

func _ready():
	_set_size(size)

func _set_size(new_size):
	size = new_size

	if cascade_sprite && cascade_sprite.scale:
		cascade_sprite.scale.y = new_size

	if particles && end_of_cascade:
		particles.global_position = end_of_cascade.global_position
