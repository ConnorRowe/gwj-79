class_name Alien
extends CharacterBody2D

enum EnemyState
{
	WALK_TO_CROP,
	DAMAGE_CROP,
	WALK_DOWN,
	DAMAGE_PLAYER
}

@onready var blink_timer: Timer = $BlinkTimer
@onready var body: AnimatedSprite2D = $Body
@onready var jiggler: Jiggler = $Body/Jiggler
@onready var main: Main = get_tree().current_scene
@onready var attack_animation_player: AnimationPlayer = $Body/EyeMarker/AttackLine2D/AttackAnimationPlayer
@onready var attack_line_2d: Line2D = $Body/EyeMarker/AttackLine2D

const SPEED = 20.0
var dir := Vector2.LEFT
var health := 3
var is_dead := false
var state := EnemyState.WALK_DOWN
var target: Node = null


func _ready() -> void:
	$AITimer.wait_time += randf_range(-0.01, 0.01)


func _physics_process(_delta: float) -> void:
	if (position.y >= 150):
		die()

	#if(velocity.length_squared() > 0):
	#	var img = body.sprite_frames.get_frame_texture(body.animation, body.frame).get_image()
	#	img.convert(Image.FORMAT_RGBA4444)
	#	main.draw_to_image.blend_rect(img, Rect2i(0,0,32,32), body.global_position + body.offset + Vector2(-16,-16))
	
	match state:
		EnemyState.DAMAGE_PLAYER:
			dir = Vector2.ZERO
		EnemyState.WALK_DOWN:
			dir = Vector2.DOWN
			if (position.y >= 130):
				change_state(EnemyState.DAMAGE_PLAYER)
		EnemyState.WALK_TO_CROP:
			if is_instance_valid(target):
				if position.distance_squared_to(target.position) <= 400:
					change_state(EnemyState.DAMAGE_CROP)
				else:
					dir = position.direction_to(target.position)
		EnemyState.DAMAGE_CROP:
			if is_instance_valid(target):
				attack_line_2d.remove_point(1)
				attack_line_2d.add_point(attack_line_2d.to_local(target.global_position))
			else:
				change_state(EnemyState.WALK_DOWN)
		
	if dir.length_squared():
		velocity = dir * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))

	move_and_slide()


func _on_blink_timer_timeout() -> void:
	blink_timer.wait_time = randf_range(2, 5)
	body.play("blink")


func deal_damage(damage: int) -> bool:
	if is_dead:
		return false
	
	health -= damage
	jiggler.jiggle(0.5)
	
	if health <= 0:
		die()
	
	return true


func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	$AnimationPlayer.play("die")
	jiggler.jiggle(1)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()


func _on_ai_timer_timeout() -> void:
	match state:
		EnemyState.WALK_DOWN, EnemyState.WALK_TO_CROP:
			var crops = main.get_crops()
			if len(crops) > 0:
				var closest = null
				var closest_dst = 99999999
				for crop in crops:
					var dst =  position.distance_squared_to(crop.position)
					if dst < closest_dst:
						closest_dst = dst
						closest = crop
				
				if not is_instance_valid(closest):
					printerr("Closest crop was not valid!")
				else:
					target = closest
					change_state(EnemyState.WALK_TO_CROP)
		
		
		EnemyState.DAMAGE_CROP:
			if not is_instance_valid(target):
				change_state(EnemyState.WALK_DOWN)


func change_state(new_state: EnemyState) -> void:
	# Old state
	match state:
		EnemyState.DAMAGE_CROP, EnemyState.DAMAGE_PLAYER:
			attack_animation_player.stop()
			attack_line_2d.visible = false
	
	# New state
	match new_state:
		EnemyState.DAMAGE_CROP:
			attack_animation_player.play("shoot_laser")
			dir = Vector2.ZERO
		EnemyState.DAMAGE_PLAYER:
			attack_animation_player.play("shoot_laser")
			target = main
			dir = Vector2.ZERO
			attack_line_2d.remove_point(1)
			attack_line_2d.add_point(Vector2(0,100))
	
	state = new_state


func do_damage() -> void:
	if is_instance_valid(target) and target.has_method("deal_damage"):
		target.deal_damage(1)
