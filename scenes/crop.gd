extends Node2D

const WABBIT = preload("res://scenes/wabbit.tscn")
const DIRT_COLOUR := Color("#663931")
const MAX_GROWTH_STEP := 8

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var carrot: Sprite2D = $Carrot
@onready var grow_timer: Timer = $GrowTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var target_carrot_global_pos: Vector2 = $CarrotMarker.global_position
@onready var crop_life = GameStatsInst.get_stat(GameStats.Stat.CROP_LIFE)

var current_growth_step := 0

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
	
	crop_life -= 1
	if crop_life <= 0:
		grow_timer.stop()
		animation_player.animation_finished.connect(func (x): queue_free())


func spawn_dirt_particles() -> void:
	GameUtils.spawn_hit_particles(global_position + Vector2(0, -10), DIRT_COLOUR)
	current_growth_step = 0


func deal_damage(_dmg: int) -> void:
	if current_growth_step < MAX_GROWTH_STEP:
		if current_growth_step > 0:
			current_growth_step -= 1
			sprite_2d.frame = current_growth_step
		grow_timer.start()
