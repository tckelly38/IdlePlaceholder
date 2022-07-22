extends KinematicBody2D

var health = 100
var attack_damage = 10
const totalCritChance = 100
var critChance = 75
var critPercent = 1.5
var idleAttackRate = 1
var isDead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var attack_timer = get_node("AttackTimer")
	attack_timer.set_wait_time(idleAttackRate)
	attack_timer.set_one_shot(false)
	add_child(attack_timer)
	attack_timer.start()
	
func get_total_attack_dam():
	randomize()
	if(randi() % totalCritChance >= critChance):
		return [attack_damage * critPercent, true]
	return [attack_damage, false]
	
func give_damage():
	$AnimationPlayer.play("shoot")
	var best_target = null
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if best_target == null:
			best_target = enemy
		elif (position.x + enemy.position.x) < (position.x + enemy.position.x):
			best_target = enemy
	var final_attack = get_total_attack_dam()
	if is_instance_valid(best_target):
		best_target.hit(final_attack[0], final_attack[1])
		
func _input(event):
	if isDead:
		return
	if Input.is_action_pressed("my_attack"):
		give_damage()

func take_damage(damage):
	health -= damage
	$AnimationPlayer.play("hit")

func _physics_process(delta):
	if health <= 0:
		isDead = true
		$AnimationPlayer.play("death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().change_scene("res://MainMenu.tscn")
	else:
		$AnimationPlayer.play("idle")

func _on_AttackTimer_timeout():
	if isDead:
		return
	give_damage()
