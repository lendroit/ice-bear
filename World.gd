extends Node2D

var new_dialog

func _ready():
	new_dialog = Dialogic.start('zero')
	$CanvasLayer.add_child(new_dialog)
	new_dialog.connect("dialogic_signal", self, 'signal_from_dialogic')
	get_tree().paused = true

func signal_from_dialogic(value):
	if (value == 'end'):
		get_tree().paused = false
		new_dialog.queue_free()
