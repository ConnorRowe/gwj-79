extends Node2D

const MAX_SEED_FRAME := 3
const CROP = preload("res://scenes/crop.tscn")

@onready var main: Main = get_tree().current_scene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var seed_sprite: Sprite2D = $SeedHolder/Seed

var draw_pixels := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(2.5).connect("timeout", seed_fall)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if draw_pixels:
		var draw_vec := Vector2(cos(GameUtils.process_tau), sin(GameUtils.process_tau))
		main.draw_pixel((draw_vec * 20) + Vector2(global_position), main.cursor_colour)
		main.draw_pixel((draw_vec * -20) + Vector2(global_position), main.cursor_colour)


func seed_fall():
	animation_player.play("seed_fall")
	draw_pixels = false


func deal_damage(_damage: int) -> bool:
	if seed_sprite.frame + 1 > MAX_SEED_FRAME:
		spawn_crop()
		queue_free()
	else:
		seed_sprite.frame += 1
	
	return true


func spawn_crop() -> void:
	var crop = CROP.instantiate()
	main.crops_holder.add_child(crop)
	crop.position = position
