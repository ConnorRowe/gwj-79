class_name Alien
extends CharacterBody2D

@onready var blink_timer: Timer = $BlinkTimer
@onready var body: AnimatedSprite2D = $Body
@onready var jiggler: Jiggler = $Body/Jiggler

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dir := Vector2.ZERO
var health := 3
var is_dead := false


func _physics_process(_delta: float) -> void:	
	if dir.length_squared():
		velocity = dir * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))

	move_and_slide()


func _on_blink_timer_timeout() -> void:
	blink_timer.wait_time = randf_range(2, 5)
	body.play("blink")


func deal_damage(damage: int) -> void:
	health -= damage
	jiggler.jiggle(0.5)
	
	if health <= 0:
		die()


func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	$AnimationPlayer.play("die")
	jiggler.jiggle(1)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
