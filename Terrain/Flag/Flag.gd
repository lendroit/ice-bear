tool
extends Node2D

func set_is_active(new_is_active):
	$Sprites/flag.visible = new_is_active
	$Sprites/raplapla.visible = !new_is_active
