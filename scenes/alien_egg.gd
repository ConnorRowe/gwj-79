extends Node2D

const ALIEN = preload("res://scenes/alien.tscn")
const MAX_HEALTH = 2

@onready var jiggler: Jiggler = $Sprite2D/Jiggler
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bullet_area_2d: Area2D = $BulletArea2D

var health = MAX_HEALTH
var is_broken := false

func deal_damage(_damage: int) -> bool:
	if is_broken:
		return false
	
	health -= 1
	sprite_2d.frame = 1
	jiggler.jiggle(0.5)
	
	if health <= 0:
		break_egg()
	
	return true

func break_egg() -> void:
	is_broken = true
	
	sprite_2d.visible = false
	var alien := ALIEN.instantiate()
	get_tree().current_scene.call_deferred("add_child", alien)
	alien.position = global_position
	alien.speed = 40
	alien.health = 20
	alien.get_node("Body").animation = "super_blink"
	alien.blink_anim = "super_blink"
	
	await get_tree().create_timer(2.5).timeout
	restore()


func restore() -> void:
	health = MAX_HEALTH
	is_broken = false
	sprite_2d.visible = true
	sprite_2d.frame = 0
