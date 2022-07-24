extends KinematicBody2D

var hit_damage = 10
var hit_rate = 1
var health = 100
var speed = 0.025
const spawn_rate = 2.0
var xp_grant = 1
signal enemy_attack
signal enemy_death

var isInAttackRange= false

var floating_text = preload("res://FloatingPoint.tscn")


func _physics_process(delta):
	if $Sprite.visible:
		if(position.x > Player.get_position().x):
			var direction = (-Player.get_position().x)
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
	emit_signal("enemy_death", xp_grant)
	# disable to prevent regen (_process func)
	set_process(false)
	get_tree().queue_delete(self)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	timer_setup("AttackTimer", hit_rate)
	
	connect("enemy_attack", Player, "on_take_damage")
	connect("enemy_death", Player, "on_enemy_death")

	
	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 1/ObjectiveContent"), "on_enemy_death")
	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 2/ObjectiveContent"), "on_enemy_death")
	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 3/ObjectiveContent"), "on_enemy_death")
	
func timer_setup(timer_name, wait_time):
	var timer = get_node(timer_name)
	timer.set_wait_time(wait_time)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

func _on_AttackTimer_timeout():
	if isInAttackRange:
		emit_signal("enemy_attack", hit_damage)

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area in get_tree().get_nodes_in_group("player_collision_wall"):
		isInAttackRange = true

