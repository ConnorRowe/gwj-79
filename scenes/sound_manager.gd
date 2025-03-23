extends Node

const GWJ_79_THEME_DRUMS = preload("res://assets/sound/music/gwj79-theme-drums.ogg")
const GWJ_79_THEME = preload("res://assets/sound/music/gwj79-theme.ogg")

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var pip_player: AudioStreamPlayer = $PipPlayer
@onready var pop_player: AudioStreamPlayer = $PopPlayer
@onready var enemy_hurt_player: AudioStreamPlayer = $EnemyHurtPlayer
@onready var shoot_player: AudioStreamPlayer = $ShootPlayer
@onready var coin_slot_player: AudioStreamPlayer = $CoinSlotPlayer
@onready var casing_bounce_player: AudioStreamPlayer = $CasingBouncePlayer

func play_drums() -> void:
	music_player.stream = GWJ_79_THEME_DRUMS
	music_player.play()

func play_theme() -> void:
	music_player.stream = GWJ_79_THEME
	music_player.play()

func pip() -> void:
	pip_player.play()

func pop() -> void:
	pop_player.play()

func enemy_hurt() -> void:
	enemy_hurt_player.play()

func shoot() -> void:
	shoot_player.play()

func coin_slot() -> void:
	coin_slot_player.play()

func casing_bounce() -> void:
	casing_bounce_player.play()
