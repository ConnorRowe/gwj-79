class_name Main
extends Node2D

const DRAW_IMAGE_UPDATE_INTERVAL := 1.0 / 30.0
const SMOKE_COLOUR = Color(Color.GRAY, 0.6)
const ALIEN = preload("res://scenes/alien.tscn")
const SEED = preload("res://scenes/seed.tscn")
const BOSS = preload("res://scenes/boss.tscn")
const TOTAL_COUNTDOWN_SECS := 180

@onready var fading_draw_canvas_texture: TextureRect = $FadingDrawCanvasTexture
@onready var jiggly_camera_2d: JigglyCamera2D = $JigglyCamera2d
@onready var debug: Label = $Reference/Debug
@onready var crops_holder: Node2D = $CropsHolder
@onready var health_bar: ProgressBar = $GUI/HealthBar
@onready var coin_stack: CoinStack = $CoinStack
@onready var shop: Shop = $Shop
@onready var shop_animation_player: AnimationPlayer = $Shop/ShopAnimationPlayer
@onready var pause_screen: Control = $PauseScreen
@onready var pause_animation_player: AnimationPlayer = $PauseScreen/PauseAnimationPlayer
@onready var transition: Transition = $Transition
@onready var countdown_label: Label = $GUI/CountdownLabel
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

@export var enemy_spawn_time_curve: Curve
@export var enemy_health_curve: Curve

var draw_to_image: Image
var draw_to_texture: ImageTexture
var draw_image_update_time := 0.0
var cursor_colour := Color(Color.RED, 0.4)
var health := 50
var countdown := TOTAL_COUNTDOWN_SECS

var rainbow_line: Image = preload("res://assets/rainbow_line.png").get_image()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_to_image = Image.create(320, 180, false, Image.FORMAT_RGBA4444)
	rainbow_line.convert(Image.FORMAT_RGBA4444)
	SoundManager.play_theme()
	_on_seed_spawn_timer_timeout()
	transition.fade_in()
	enemy_spawn_time_curve.bake()
	enemy_health_curve.bake()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug.text = "%d fps" % Engine.get_frames_per_second() 
	
	# Draw cursor
	cursor_colour.h = wrapf(cursor_colour.h + delta, 0.0, 1.0)
	var centre_mouse = Vector2i(get_global_mouse_position())
	draw_pixel(centre_mouse, cursor_colour)
	draw_pixel(centre_mouse + Vector2i(1,0), cursor_colour)
	draw_pixel(centre_mouse + Vector2i(1,1), cursor_colour)
	draw_pixel(centre_mouse + Vector2i(0,1), cursor_colour)
	
	draw_image_update_time -= delta
	
	if draw_image_update_time > 0:
		return
	else:
		draw_image_update_time += DRAW_IMAGE_UPDATE_INTERVAL
	
	# Fade screen tex
	for x in range(320):
		for y in range(180):
			var current_colour = draw_to_image.get_pixel(x, y)
			if current_colour.a <= 0:
				continue
			draw_to_image.set_pixel(x, y, Color(current_colour, max(0, current_colour.a - (2*delta))))
	
	draw_to_texture = ImageTexture.create_from_image(draw_to_image)
	fading_draw_canvas_texture.texture = draw_to_texture


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()


func shake_screen(amount: float) -> void:
	jiggly_camera_2d.jiggle(amount)


func _on_player_on_player_shoot() -> void:
	#shake_screen(1)
	pass


func draw_rainbow_line(pos: Vector2i) -> void:
	draw_to_image.blend_rect(rainbow_line, Rect2i(0, 0, 4, 14), pos)


func draw_smoke_trail(pos: Vector2i) -> void:
	draw_pixel(pos, SMOKE_COLOUR)


func draw_pixel(pos: Vector2i, colour: Color) -> void:
	if pos.x > 0 and pos.x < 320 and pos.y > 0 and pos.y < 180:
		draw_to_image.set_pixelv(pos, colour)


func get_crops() -> Array:
	return crops_holder.get_children()


func deal_damage(dmg: int) -> void:
	health -= dmg
	health_bar.value = health
	if health <= 0:
		game_over()


func game_over() -> void:
	GameStatsInst.reset_stats()
	transition.transition_to_scene("res://scenes/lose_screen.tscn")


func _on_enemy_spawn_timer_timeout() -> void:
	var alien = ALIEN.instantiate()
	add_child(alien)
	alien.position = Vector2(randf_range(60, 300), randf_range(-12, -8))
	alien.health = enemy_health_curve.sample_baked(1.0 - (float(countdown) / float(TOTAL_COUNTDOWN_SECS)))


func _on_shop_bell_on_bell_rung() -> void:
	get_tree().paused = true

	for child in get_children():
		if child is Bullet:
			child.queue_free()
	
	shop.opening_shop()
	coin_stack.z_index = 10
	shop_animation_player.play("show")


func _on_shop_shop_closed() -> void:
	coin_stack.z_index = 0
	shop_animation_player.play_backwards("show")
	
	await shop_animation_player.animation_finished
	get_tree().paused = false


func pause() -> void:
	if not shop.is_open:
		pause_screen.is_in_pause_menu = true
		pause_animation_player.play("show")
		get_tree().paused = true


func _on_pause_screen_unpause() -> void:
	pause_animation_player.play_backwards("show")
	
	await pause_animation_player.animation_finished
	get_tree().paused = false
	pause_screen.is_in_pause_menu = false


func _on_seed_spawn_timer_timeout() -> void:
	var new_seed = SEED.instantiate()
	add_child(new_seed)
	new_seed.position = Vector2(randf_range(60, 300), randf_range(80, 130))


func _on_countdown_timer_timeout() -> void:
	countdown -= 1
	update_countdown_clock()
	
	var spawn_curve_offset = 1.0 - (float(countdown) / float(TOTAL_COUNTDOWN_SECS))
	enemy_spawn_timer.wait_time = enemy_spawn_time_curve.sample_baked(spawn_curve_offset)
	
	if countdown <= 0:
		countdown_label.visible = false
		$SeedSpawnTimer.stop()
		enemy_spawn_timer.stop()
		$CountdownTimer.stop()
		for child in get_children():
			if child is Alien:
				child.die()
		
		var boss = BOSS.instantiate()
		add_child(boss)
		
		var boss_health_bar: ProgressBar = $GUI/BossHealthBar
		boss_health_bar.visible = true
		create_tween().tween_property(boss_health_bar, "modulate", Color.WHITE, 3).from(Color.TRANSPARENT)
		
		boss.on_health_changed.connect(func(x): boss_health_bar.value = x)
		boss.on_boss_dead.connect(win_game)
		

func update_countdown_clock() -> void:
	var minutes := floori(float(countdown) / 60.0)
	var seconds := str(countdown - (minutes * 60))
	if len(seconds) < 2:
		seconds = '0' + seconds
	countdown_label.text = "%d:%s" % [minutes, seconds]


func win_game() -> void:
	await get_tree().create_timer(8).timeout
	GameStatsInst.reset_stats()
	transition.transition_to_scene("res://scenes/win_screen.tscn")
