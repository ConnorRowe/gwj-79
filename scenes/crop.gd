extends Node2D

const WABBIT = preload("res://scenes/wabbit.tscn")
const DIRT_COLOUR := Color("#663931")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var carrot: Sprite2D = $Carrot
@onready var grow_timer: Timer = $GrowTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const MAX_GROWTH_STEP := 8
var current_growth_step := 0
@onready var target_carrot_global_pos: Vector2 = $CarrotMarker.global_position

func _on_grow_timer_timeout() -> void:
	current_growth_step += 1
	
	if current_growth_step > MAX_GROWTH_STEP:
		spawn_carrot()
		current_growth_step = 9
		grow_timer.stop()
		get_tree().create_timer(3.0).timeout.connect(grow_timer.start)
	
	sprite_2d.frame = current_growth_step


func spawn_carrot() -> void:
	var wabbit = WABBIT.instantiate()
	get_tree().current_scene.add_child(wabbit)
	wabbit.position = target_carrot_global_pos
	animation_player.play("shoot_carrot_up")


func spawn_dirt_particles() -> void:
	GameUtils.spawn_hit_particles(global_position + Vector2(0, -10), DIRT_COLOUR)
	current_growth_step = 0
