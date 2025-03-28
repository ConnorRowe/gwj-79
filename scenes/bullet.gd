class_name Bullet
extends Area2D

const ALIEN_HIT_COLOUR := Color("#99e550")

@onready var expiration_timer: Timer = $ExpirationTimer

var trail_points := PackedVector2Array([Vector2(0, 3), Vector2(0, 5), Vector2(0, 7)])
var trail_colours := PackedColorArray([Color(Color.WHITE, 0.7), Color(Color.WHITE, 0.4), Color(Color.WHITE, 0.0)])
var dir := Vector2.ZERO
var speed := 200.0
var damage := 1


func init_bullet(bullet_dir: Vector2, dmg: int):
	dir = bullet_dir
	damage = dmg
	rotation = dir.angle() + (PI/2)
	queue_redraw()


func _physics_process(delta: float) -> void:
	position += dir * delta * speed


func _draw() -> void:
	draw_polyline_colors(trail_points, trail_colours, 2)


func _on_area_entered(area: Area2D) -> void:
	if area.owner.has_method("deal_damage") and area.owner.deal_damage(damage):
		GameUtils.spawn_hit_particles(global_position, ALIEN_HIT_COLOUR)
		SoundManager.enemy_hurt()
		queue_free()


func _on_expiration_timer_timeout() -> void:
	queue_free()
