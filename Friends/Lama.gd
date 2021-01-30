extends Area2D


func on_pickup():
	print("lama picked up!")
	queue_free()
