extends Area2D

signal trigger_dialog

var friend_name = ""

func on_pickup():
	queue_free()
	emit_signal("trigger_dialog", friend_name)
