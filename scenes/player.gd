class_name Player
extends Node2D

signal on_player_shoot

const BULLET = preload("res://scenes/bullet.tscn")
const SPENT_CASING = preload("res://scenes/spent_casing.tscn")

const ANGLE_MIN := deg_to_rad(-175)
const ANGLE_MAX := deg_to_rad(-5)

@onready var shoot_marker: Marker2D = $ShootMarker
@onready var turret_barrel: Sprite2D = $BarrelRoot/TurretBarrel
@onready var shoot_timer: Timer = $ShootTimer
@onready var barrel_jiggler: Jiggler = $BarrelRoot/BarrelJiggler
@onready var base_jiggler: Jiggler = $TurretBase/BaseJiggler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var feed_anim: Animation = $AnimationPlayer.get_animation("feed")
@onready var rat: Sprite2D = $Rat

var dir := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStatsInst.stat_changed.connect(game_stat_changed)
	shoot_timer.wait_time = GameStatsInst.get_stat(GameStats.Stat.FIRE_RATE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Figure out angle
	var angle := clampf(shoot_marker.global_position.direction_to(get_global_mouse_position()).angle(), ANGLE_MIN, ANGLE_MAX)
	#var angle = target_pos.angle()
	dir = Vector2(cos(angle), sin(angle))
	turret_barrel.rotation = angle + PI/2
	
	# Place rat
	rat.position = shoot_marker.position - (dir * 10)
	rat.flip_h = rat.position.x < 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_shoot"):
		if shoot_timer.is_stopped():
			shoot()
			shoot_timer.start()
			animation_player.play("feed")
			feed_anim.loop_mode = Animation.LOOP_LINEAR
	elif event.is_action_released("player_shoot"):
		feed_anim.loop_mode = Animation.LOOP_NONE


func _on_shoot_timer_timeout() -> void:
	if(Input.is_action_pressed("player_shoot")):
		shoot()
	else:
		shoot_timer.stop()


func shoot() -> void:
	# Spawn bullet
	var bullet = BULLET.instantiate()
	get_parent().add_child(bullet)
	bullet.position = shoot_marker.global_position
	bullet.init_bullet(dir, GameStatsInst.get_stat(GameStats.Stat.BULLET_DMG))
	
	# Sound
	SoundManager.shoot()
	
	# Emit signal that we shot
	on_player_shoot.emit()
	
	# Jiggle baby
	barrel_jiggler.jiggle(1)
	base_jiggler.jiggle(1)	
	
	# Spawn casing
	var casing = SPENT_CASING.instantiate()
	get_parent().add_child(casing)
	casing.position = shoot_marker.global_position


func game_stat_changed(stat: GameStats.Stat, value: Variant) -> void:
	if stat == GameStats.Stat.FIRE_RATE:
		shoot_timer.wait_time = maxf(0.0166666666667, value)
