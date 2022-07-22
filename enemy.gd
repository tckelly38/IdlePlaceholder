extends KinematicBody2D

var hit_damage = 10
var hit_rate = 1
var health = 100
var speed = 0.01
const spawnRate = 2.0

signal enemy_attack
var isInAttackRange= false

var floating_text = preload("res://FloatingPoint.tscn")

onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if $Sprite.visible:
		var direction = (player.get_position().x - position.x)
		var motion = direction * speed
		position.x += motion
		
func hit(damage, isCrit):
	health -= damage
	var text = floating_text.instance()
	text.amount = damage
	if isCrit:
		text.type = "Critical"
	else:
		text.type = "Damage"
	add_child(text)
	if(health <= 0):
		die()
	else:
		$AnimationPlayer.play("hit")
		
func die():
	# disable to prevent regen (_process func)
	set_process(false)
	get_tree().queue_delete(self)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	var attack_timer = get_node("AttackTimer")
	attack_timer.set_wait_time(hit_rate)
	attack_timer.set_one_shot(false)
	add_child(attack_timer)
	attack_timer.start()
	
	connect("enemy_attack", player, "take_damage")

func _on_AttackTimer_timeout():
	if isInAttackRange:
		emit_signal("enemy_attack", hit_damage)

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area in get_tree().get_nodes_in_group("player_collision_wall"):
		isInAttackRange = true

