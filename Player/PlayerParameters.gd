extends Node2D

#		WALK VARIALES
export (int) var PLAYER_WALK_SPEED = 600
export (float, 0, 1.0) var PLAYER_WALK_ACCELERATION = 0.25
export (float, 0, 1.0) var PLAYER_WALK_FRICTION = .55

export (int) var PLAYER_GRAPPLING_HOOK_SPEED = 2000

#		CRAWL VARIALES
export (int) var PLAYER_CRAWL_SPEED = 200
export (float, 0, 1.0) var PLAYER_CRAWL_ACCELERATION = 0.75
export (float, 0, 1.0) var PLAYER_CRAWL_FRICTION = .9

#		HOVER VARIALES
export (int) var PLAYER_HOVER_SPEED = 225
export (float, 0, 1.0) var PLAYER_AIR_FRICTION = .1

#		JUMP VARIALES
export (int) var PLAYER_JUMP_SPEED = -1300
export (int) var PLAYER_MAX_JUMPS = 1

#		SHOOT VARIALES
export (float) var PLAYER_SHOOT_TIMER_TIME = 0.5
export var PLAYER_SPIT_VELOCITY = 1500


export (int) var PLAYER_HEALTH_POINTS = 2

#		POWER (DE)ACTIVATION
export var PLAYER_CAN_GLAIRE = false
export var PLAYER_CAN_HOVER = false
export var PLAYER_CAN_CRAWL = false # Buggy & Unexploited feature
export var PLAYER_CAN_HOOK = false
export var PLAYER_CAN_BUILD = false

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
