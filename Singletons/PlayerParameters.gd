extends Node

#		WALK VARIALES
var PLAYER_WALK_SPEED = 600
var PLAYER_WALK_ACCELERATION = 0.25
var PLAYER_WALK_FRICTION = .55

var PLAYER_GRAPPLING_HOOK_SPEED = 2000

#		HOVER VARIALES
var PLAYER_HOVER_SPEED = 225
var PLAYER_AIR_FRICTION = .1

#		JUMP VARIALES
var PLAYER_JUMP_SPEED = -1300
var PLAYER_MAX_JUMPS = 1

#		SHOOT VARIALES
var PLAYER_SHOOT_TIMER_TIME = 0.5
var PLAYER_SPIT_VELOCITY = 1500


var PLAYER_HEALTH_POINTS = 1

#		POWER (DE)ACTIVATION
var PLAYER_CAN_GLAIRE = false
var PLAYER_CAN_HOVER = false
var PLAYER_CAN_HOOK = false
var PLAYER_CAN_BUILD = false

var PLAYER_SPIT_SOUNDS = [
	preload("res://assets/sound/spit/spit1.wav"),
	preload("res://assets/sound/spit/spit2.wav"),
	preload("res://assets/sound/spit/spit3.wav"),
	preload("res://assets/sound/spit/spit4.wav"),
	preload("res://assets/sound/spit/spit5.wav"),
	preload("res://assets/sound/spit/spit6.wav"),
	preload("res://assets/sound/spit/spit7.wav"),
	preload("res://assets/sound/spit/spit8.wav"),
	preload("res://assets/sound/spit/spit9.wav"),
	preload("res://assets/sound/spit/spit10.wav"),
	preload("res://assets/sound/spit/spit11.wav"),
	preload("res://assets/sound/spit/spit12.wav"),
	preload("res://assets/sound/spit/spit13.wav"),
	preload("res://assets/sound/spit/spit14.wav")
 ]

var PLAYER_DEATH_SOUNDS = [
	preload("res://assets/sound/player_death/death_01_session.wav"),
	preload("res://assets/sound/player_death/death_02_session.wav"),
	preload("res://assets/sound/player_death/death_03_session.wav"),
	preload("res://assets/sound/player_death/death_04_session.wav"),
	preload("res://assets/sound/player_death/death_05_session.wav"),
	preload("res://assets/sound/player_death/death_06_session.wav"),
	preload("res://assets/sound/player_death/death_07_session.wav"),
	preload("res://assets/sound/player_death/death_08_session.wav"),
	preload("res://assets/sound/player_death/death_09_session.wav")
]

var PLAYER_BEAVER_TOSS_SOUNDS = [
	preload("res://assets/sound/beaver_toss/beaver_toss_1.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_2.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_3.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_4.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_5.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_6.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_7.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_8.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_9.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_10.wav"),
	preload("res://assets/sound/beaver_toss/beaver_toss_11.wav")
]
