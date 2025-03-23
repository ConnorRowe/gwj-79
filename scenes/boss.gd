extends Node2D

signal on_health_changed(health_percentage: float)
signal on_boss_dead

const EXPLOSION = preload("res://scenes/explosion.tscn")
const ALIEN_EGG = preload("res://scenes/alien_egg.tscn")
const MAX_HEALTH := 500

var egg_1: Node2D
var egg_2: Node2D
@onready var egg_holder: Node2D = $BossHolder/EggHolder
@onready var boss_holder: Node2D = $BossHolder
@onready var jiggler: Jiggler = $BossHolder/HeadHolder/Sprite2D/Jiggler

var phase := 1
var movement_speed := 0.0
var movement_vector := Vector2.ZERO
var movement_count := PI
var is_dead := false
var health := MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	egg_1 = ALIEN_EGG.instantiate()
	egg_2 = ALIEN_EGG.instantiate()
	
	egg_holder.add_child(egg_1)
	egg_holder.add_child(egg_2)
	
	egg_holder.scale = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		return
		
	var dir_vec := Vector2(cos(GameUtils.process_tau), sin(GameUtils.process_tau))
	egg_1.position = dir_vec * 60
	egg_2.position = dir_vec * -60
	
	if phase > 1:
		movement_count = wrapf(movement_count + (delta * movement_speed), 0, TAU)
		boss_holder.position =  Vector2(160, 54) + (movement_vector * Vector2(cos(movement_count), sin(movement_count)))


func show_eggs() -> void:
	create_tween().tween_property(egg_holder, "scale", Vector2.ONE, 0.5)


func change_phase(new_phase: int) -> void:
	if phase != new_phase:
		phase = new_phase
		
		if new_phase == 2:
			movement_speed = 1.5
			movement_vector = Vector2(120, 30)
		elif new_phase == 3:
			movement_speed = 3.0


func deal_damage(damage: int) -> bool:
	if is_dead:
		return false
	
	health -= damage
	jiggler.jiggle(0.5)
	
	var hp_percent = float(health) / float(MAX_HEALTH)
	on_health_changed.emit(hp_percent)
	
	if hp_percent <= 0.6667 and hp_percent > 0.3334:
		change_phase(2)
	elif hp_percent <= 0.3334:
		change_phase(3)
	
	if health <= 0:
		die()
	
	return true


func die() -> void:
	is_dead = true
	egg_holder.queue_free()
	on_boss_dead.emit()
	var explosion = EXPLOSION.instantiate()
	$BossHolder/HeadHolder/Sprite2D.add_child(explosion)
	explosion.get_node("ExposionSoundTimer").timeout.connect(func(): jiggler.jiggle(1))
	$AnimationPlayer.play("die")
