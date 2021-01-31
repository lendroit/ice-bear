extends AnimatedSprite

func _open_backpack():
	self.frame = 1

func add_friend(friend):
	if(friend is Lama):
		$Lama.visible = true
		_open_backpack()
	if(friend is Snake):
		$Snake.visible = true
		_open_backpack()
	if(friend is Crow):
		$Crow.visible = true
		_open_backpack()
	if(friend is Beaver):
		$Beaver.visible = true
		_open_backpack()
	if(friend is Kangaroo):
		$Kangaroo.visible = true
		_open_backpack()
