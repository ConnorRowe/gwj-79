extends Node2D

var velocity := Vector2.ZERO

const BOUNCE_FLOOR := 170
const GRAVITY := 980.0
const DAMPING := 15

@onready var sprite_2d: Sprite2D = $Sprite2D
var main: Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(randf_range(40, 60) * (1 if (randf() > .5) else -1), randf_range(-300, -160))
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, $ExpirationTimer.wait_time/2).from_current().set_delay($ExpirationTimer.wait_time/2)
	
	main = get_tree().current_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite_2d.rotation += velocity.x * delta * randf_range(0.1, .3)
	main.draw_smoke_trail(Vector2i(global_position))


func _physics_process(delta: float) -> void:
	
	if position.y > BOUNCE_FLOOR and velocity.y > 2:
		velocity.y *= -0.8
	
	if position.y < BOUNCE_FLOOR:
		velocity.y += GRAVITY * delta
	
	velocity = Vector2(move_toward(velocity.x, 0, DAMPING * delta), move_toward(velocity.y, 0, DAMPING * delta))
	
	position += velocity * delta


func _on_expiration_timer_timeout() -> void:
	queue_free()
