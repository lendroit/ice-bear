extends Area2D

signal PlayerInDeathZone

func _on_DeathZone_body_shape_entered(body_id, body, body_shape, area_shape):
	print("death zone for ", body_id)
	emit_signal("PlayerInDeathZone")
