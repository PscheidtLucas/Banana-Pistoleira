class_name Destructible extends CharacterBody2D

var is_alive: bool = true
var health: int = 3
const CORACAO = preload("res://game/coracao.tscn")
@onready var hit_sound: AudioStreamPlayer2D = %HitSound
@onready var box_sprite: Sprite2D = $BoxSprite
@onready var damage_particle: GPUParticles2D = %DamageParticle

@onready var mat : ShaderMaterial = box_sprite.material


func take_damage(amount: int, bullet_dir: Vector2):
	if is_alive:
		mat.set("shader_parameter/flash_strength", 1.0)
		
		var particle_direction := bullet_dir.normalized()
		damage_particle.process_material.set("direction", particle_direction)
		damage_particle.restart()
		
		hit_sound.play()
		print("caixa tomou dano")
		health -= amount
		if health <= 0:
			var health_drop := CORACAO.instantiate()
			health_drop.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", health_drop)
			die()
		await get_tree().create_timer(0.05).timeout
		mat.set("shader_parameter/flash_strength", 0.0)


func die() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	is_alive = false
	box_sprite.hide()
	$Shadow.hide()
	$DestroySound.play()
	set_physics_process(false)
	set_process(false)
	
	await get_tree().create_timer(2).timeout
	queue_free()
