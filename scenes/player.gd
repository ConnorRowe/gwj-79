class_name Player
extends Node2D

signal on_player_shoot

const BULLET = preload("res://scenes/bullet.tscn")
const SPENT_CASING = preload("res://scenes/spent_casing.tscn")

const ANGLE_MIN := deg_to_rad(-160)
const ANGLE_MAX := deg_to_rad(-20)

@onready var shoot_marker: Marker2D = $ShootMarker
@onready var turret_barrel: Sprite2D = $BarrelRoot/TurretBarrel
@onready var shoot_timer: Timer = $ShootTimer
@onready var barrel_jiggler: Jiggler = $BarrelRoot/BarrelJiggler
@onready var base_jiggler: Jiggler = $TurretBase/BaseJiggler

var dir := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var angle := clampf(shoot_marker.global_position.direction_to(get_global_mouse_position()).angle(), ANGLE_MIN, ANGLE_MAX)
	#var angle = target_pos.angle()
	dir = Vector2(cos(angle), sin(angle))
	turret_barrel.rotation = angle + PI/2
	queue_redraw()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_shoot"):
		if shoot_timer.is_stopped():
			shoot()
			shoot_timer.start()
	elif event.is_action_released("player_shoot"):
		shoot_timer.stop()


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
	bullet.init_bullet(dir)
	
	# Emit signal that we shot
	on_player_shoot.emit()
	
	# Jiggle baby
	barrel_jiggler.jiggle(1)
	base_jiggler.jiggle(1)
	
	
	# Spawn casing
	var casing = SPENT_CASING.instantiate()
	get_parent().add_child(casing)
	casing.position = shoot_marker.global_position
