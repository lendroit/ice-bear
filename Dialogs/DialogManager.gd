tool
extends Control

export(FriendsParameters.ENUM) var current_dialog_name setget set_current_dialog

signal end

onready var friends_mapping = {
	FriendsParameters.ENUM.lama: $Lama,
	FriendsParameters.ENUM.beaver: $Beaver,
	FriendsParameters.ENUM.kangaroo: $Kangaroo,
	FriendsParameters.ENUM.snake: $Snake,
	FriendsParameters.ENUM.crow: $Crow,
}

func _ready():
	for child in get_children():
		child.connect("end", self, "end_dialog")

func _hide_all_friends():
	for friend in friends_mapping.values():
		friend.visible = false

func start(dialog_name: int):
	_hide_all_friends()

	var current_friend = friends_mapping[FriendsParameters.ENUM.beaver]
	if current_friend:
		current_friend.visible = true
		current_friend.start()
		return

	emit_signal("end")

func end_dialog():
	emit_signal("end")

func set_current_dialog(new_dialog: int):
	start(new_dialog)
