extends KinematicBody2D

var hit_damage = 10
var hit_rate = 1
var health = 100
var speed = 0.025
const spawn_rate = 0.5
var xp_grant = 1
signal enemy_attack
signal enemy_death
var is_boss

var is_dead = false

var isInAttackRange= false

var floating_text = preload("res://FloatingPoint.tscn")
signal slime_boss_died

func make_boss():
	get_node("Sprite").scale = Vector2(10, 10)
	speed = 0.01
	xp_grant = 100
	hit_damage = 100
	health = 1000
	is_boss = true
	
func _physics_process(_delta):
	if $Sprite.visible:
		if(position.x > Player.get_position().x):
			var direction = (-Player.get_position().x)
			var motion = direction * speed
			position.x += motion
		
func hit(damage, isCrit):
	health -= damage
	var text = floating_text.instance()
	text.content = str(damage)
	if isCrit:
		text.type = "Critical"
	else:
		text.type = "Damage"
	add_child(text)
	if(health <= 0):
		die()
	else:
		$AnimationPlayer.play("hit")
		
func on_particle_finish():
	# disable to prevent regen (_process func)
	set_process(false)
	get_tree().queue_delete(self)
	
func die():
	is_dead = true
	emit_signal("enemy_death", xp_grant, position)
	if is_boss:
		emit_signal("slime_boss_died")
		
	var particle_timer = Timer.new()
	particle_timer.set_wait_time(get_node("ParticleDeath").lifetime)
	particle_timer.set_one_shot(true)
	particle_timer.connect("timeout", self, "on_particle_finish")
	$Sprite.visible = false
	$AttackTimer.stop()
	add_child(particle_timer)
		
	get_node("ParticleDeath").emitting = true
	particle_timer.start()
	


	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	timer_setup("AttackTimer", hit_rate)
	is_boss = false
	
	var error_code = connect("enemy_attack", Player, "on_take_damage")
	if error_code:
		print("Error: error unable to connect to Player.on_take_damage from enemy")
	
	error_code = connect("enemy_death", Player, "on_enemy_death")
	if error_code:
		print("Error: error unable to connect to Player.on_enemy_death from enemy")

	var obj = get_node("/root/FarmArea1/ObjContainer")
	if obj.has_method("on_enemy_death"):
		error_code = connect("enemy_death", get_node("/root/FarmArea1/ObjContainer"), "on_enemy_death")
		if error_code:
			print("Error: error unable to connect to ObjContainer from enemy")
			
	error_code = connect("enemy_death", get_node("/root/FarmArea1"), "on_enemy_death")
	if error_code:
			print("Error: error unable to connect to farm area from enemy")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 2/ObjectiveContent"), "on_enemy_death")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 3/ObjectiveContent"), "on_enemy_death")
	
func timer_setup(timer_name, wait_time):
	var timer = get_node(timer_name)
	timer.set_wait_time(wait_time)
	timer.set_one_shot(false)

	timer.start()

func _on_AttackTimer_timeout():
	if isInAttackRange:
		emit_signal("enemy_attack", hit_damage)

func _on_Area2D_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area in get_tree().get_nodes_in_group("player_collision_wall"):
		isInAttackRange = true

