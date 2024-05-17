extends Node

const CAVE_EXPLOSION = preload("res://assets/sounds/cave_explosion.mp3")
const FALLING_ROCKS = preload("res://assets/sounds/falling_rocks.mp3")
const ROCK_BREAK = preload("res://assets/sounds/rock_break.mp3")
const WOOD_WORKING = preload("res://assets/sounds/wood_working.mp3")
const EXPLOSION = preload("res://assets/sounds/explosion.mp3")

enum SOUND_TYPE { FALLING_ROCKS, EXPLOSION, EXPLOSION_CAVE, PICKAXE_ROCKS, WOOD_WORKING }

func play(player: AudioStreamPlayer, type: SOUND_TYPE):
	match type:
		SOUND_TYPE.FALLING_ROCKS:
			player.stream = FALLING_ROCKS
			player.play()
		SOUND_TYPE.EXPLOSION_CAVE:
			player.stream = CAVE_EXPLOSION
			player.play()
		SOUND_TYPE.PICKAXE_ROCKS:
			player.stream = ROCK_BREAK
			player.play()
		SOUND_TYPE.WOOD_WORKING:
			player.stream = WOOD_WORKING
			player.play()
		SOUND_TYPE.EXPLOSION:
			player.stream = EXPLOSION
			player.play()
