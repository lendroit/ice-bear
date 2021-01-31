extends Control

signal end

onready var lama = $Lama

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func start(dialog_name: String):
	lama.start()

func end_dialog():
	emit_signal("end")
