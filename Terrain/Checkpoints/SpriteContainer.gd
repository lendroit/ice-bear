tool
extends Node2D

onready var active_sprite = $ActiveSprite
onready var inactive_sprite = $InactiveSprite

func my_set_sprite(is_active):
	if(active_sprite && inactive_sprite):
		active_sprite.set_visible(is_active)
		inactive_sprite.set_visible(!is_active)
