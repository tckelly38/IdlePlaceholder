extends KinematicBody2D

var current_health = 100
var max_health = 100
var attack = 10
const total_crit_chance = 100
var crit_chance = 75
var crit_percent = 1.5
var idle_attack_rate = 1
var defense = 0.99
var is_dead = false
var regen_rate = 1
var regen_percent = 1.1
var total_experience = 0
var xp_level = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	timer_setup("AttackTimer", idle_attack_rate)
	timer_setup("RegenTimer", regen_rate)

func timer_setup(timer_name, wait_time):
	var timer = get_node(timer_name)
	timer.set_wait_time(wait_time)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	
func get_total_attack_dam():
	randomize()
	if(randi() % total_crit_chance >= crit_chance):
		return [attack * crit_percent, true]
	return [attack, false]
	
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
	if is_dead:
		return
	if Input.is_action_pressed("my_attack"):
		give_damage()

func take_damage(damage):
	current_health -= damage * defense
	$AnimationPlayer.play("hit")

func _physics_process(delta):
	if current_health <= 0:
		is_dead = true
		$AnimationPlayer.play("death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().change_scene("res://MainMenu.tscn")
	else:
		$AnimationPlayer.play("idle")

func _on_AttackTimer_timeout():
	if !is_dead:
		give_damage()
	
func save():
	var save_dict = {
		"filename": get_filename(),
		"attack": attack,
		"defense": defense,
		"current_health": current_health,
		"max_health": max_health,
		"regen_rate": regen_rate,
		"regen_percent": regen_percent,
		"total_experience": total_experience,
		"xp_level": xp_level,
		"total_crit_chance": total_crit_chance,
		"crit_chance": crit_chance,
		"crit_percent": crit_percent
	}
	return save_dict


func _on_RegenTimer_timeout():
	if !is_dead:
		current_health = min(current_health * regen_percent, max_health)

