class_name Alien
extends CharacterBody2D

@onready var blink_timer: Timer = $BlinkTimer
@onready var body: AnimatedSprite2D = $Body

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dir := Vector2.ZERO


func _physics_process(delta: float) -> void:	
	if dir.length_squared():
		velocity = dir * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))

	move_and_slide()


func _on_blink_timer_timeout() -> void:
	blink_timer.wait_time = randf_range(2, 5)
	body.play("blink")
