extends Node2D

onready var reachable_hooks_area = $ReachableHooksArea
onready var grappling_hook_rope = $GrapplingHookRope
onready var hook_position_tween = $HookPositionTween

# PUBLIC
var hook_direction = Vector2.ZERO
####

var hooked_node
var player

func custom_init(parent):
	self.player = parent

func hook():
	if (!PlayerParameters.PLAYER_CAN_HOOK):
		return

	var hooks_in_area = reachable_hooks_area.get_overlapping_areas()
	var upper_hooks = Utils.filter(funcref(self, "keep_upper_hooks"), hooks_in_area)
	if (upper_hooks.size() == 0):
		return

	var uppest_hook = Utils.reduce(funcref(self, "get_higher_hook"), upper_hooks, upper_hooks[0])
	hooked_node = uppest_hook
	grappling_hook_rope.visible = true

	hook_direction = (uppest_hook.position - player.position).normalized() * PlayerParameters.PLAYER_GRAPPLING_HOOK_SPEED
	hook_position_tween.interpolate_property(player, "velocity", player.velocity, hook_direction, 0.1, Tween.TRANS_LINEAR)
	hook_position_tween.start()

func draw_hook():
	if (!hooked_node):
		grappling_hook_rope.visible = false
		return

	grappling_hook_rope.visible = true
	var rope_direction =  (hooked_node.position - player.position)
	var rope_position = rope_direction/2
	var rope_angle = rope_direction.angle()
	var rope_length = rope_direction.length()
	grappling_hook_rope.position = rope_position
	grappling_hook_rope.rotation = rope_angle
	grappling_hook_rope.scale.x = rope_length/1000

func _on_HookPositionTween_tween_all_completed():
	hooked_node = null

func keep_upper_hooks(hook_area: Area2D)->bool:
	return hook_area.position.y < player.position.y

func get_higher_hook(uppest_hook: Area2D, hook: Area2D)->Area2D:
	if (uppest_hook.position.y > hook.position.y):
		return hook

	return uppest_hook

