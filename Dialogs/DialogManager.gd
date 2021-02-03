tool
extends Control

export(String, "lama", "beaver", "kangaroo", "snake", "crow") var current_dialog_name setget set_current_dialog

signal end

onready var friends_mapping = {
	# TODO use enum for keys
	"lama": $Lama,
	"beaver": $Beaver,
	"kangaroo": $Kangaroo,
	"snake": $Snake,
	"crow": $Crow,
}

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func _hide_all_friends():
	for friend in friends_mapping.values():
		friend.visible = false

func start(dialog_name: String):
	_hide_all_friends()

	var current_friend = friends_mapping[dialog_name]
	if current_friend:
		current_friend.visible = true
		current_friend.start()
		return

	emit_signal("end")

func end_dialog():
	emit_signal("end")

func set_current_dialog(new_dialog: String):
	start(new_dialog)
