tool
extends Node2D

export (int) var size = 3 setget set_size

onready var cascade = $Cascade
onready var end_of_cascade = $Cascade/EndOfCascade
onready var particles = $Particles2D

func set_size(new_size):
	size = new_size

	if cascade && cascade.scale:
		cascade.scale.y = new_size

	if particles && end_of_cascade:
		particles.global_position = end_of_cascade.global_position
