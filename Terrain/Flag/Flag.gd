tool
extends Node2D

onready var animation_player = $AnimationPlayer

func set_is_active(new_is_active):
	if new_is_active:
		animation_player.play("Activate")
	else:
		animation_player.play("Inactive")

	$Sprites/flag.visible = new_is_active
	$Sprites/raplapla.visible = !new_is_active
