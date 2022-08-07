extends KinematicBody2D

var current_health = 100
var max_health = 100
var attack = 10
const total_crit_chance = 100
var crit_chance = 10
var crit_percent = 1.5
var idle_attack_rate = 3
var defense = 0.99
var is_dead = false
var regen_rate = 1
var regen_percent = 1.1

var level = 0
var xp_in_current_level = 0
var experience_total = 0
var experience_in_level = 0

var experience_requred = get_required_experience(level + 1)
signal experience_gained
signal level_up
signal update_health

var is_xp_bar_ready = false

func get_required_experience(level_):
	return round(pow(level_, 1.75) + level_ * 8 + 10)

func gain_experience(amount):
	experience_total += amount
	experience_in_level += amount

	while experience_in_level >= experience_requred:
		experience_in_level -= experience_requred
		level_up()

	emit_signal("experience_gained", experience_in_level, experience_requred)

func level_up():
	level += 1
	emit_signal("level_up")
	experience_requred = get_required_experience(level + 1)
	max_health += 10
	attack += 1
	crit_chance += 1
	
	
	current_health = max_health
	#var stats = ['max_health', 'attack', 'crit_chance', 'crit_percent', 'idle_attack_rate', 'defense', 'regen_rate', 'regen_percent']
	#var random_stat = stats[randi() % stats.size()]
	emit_signal("update_health", current_health, max_health)
	
	
	#set(random_stat, get(random_stat) + randi() % 4 + 2)

		
# Called when the node enters the scene tree for the first time.
func _ready():
	timer_setup("AttackTimer", idle_attack_rate)
	timer_setup("RegenTimer", regen_rate)

func timer_setup(timer_name, wait_time):
	var timer = get_node(timer_name)
	timer.set_wait_time(wait_time)
	timer.set_one_shot(false)
	timer.start()
	
func get_total_attack_dam():
	randomize()
	if(randi() % total_crit_chance + 1 <= crit_chance):
		return [attack * crit_percent, true]
	return [attack, false]
	
func give_damage():
	if is_dead:
		return
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
		
func _input(_event):
	if is_dead:
		return
	if Input.is_action_pressed("my_attack"):
		give_damage()

func on_take_damage(damage):
	if is_dead:
		return
	current_health -= damage * defense
	$AnimationPlayer.play("hit")
	emit_signal("update_health", current_health, max_health)

func on_enemy_death(xp):
	gain_experience(xp)
	
func on_objective_finished(xp):
	gain_experience(xp)
	
func _physics_process(_delta):
	if current_health <= 0 and !is_dead:
		is_dead = true
		$AnimationPlayer.play("death")
		#yield($AnimationPlayer, "animation_finished")
		#var error_code = get_tree().change_scene("res://MainMenu.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		var error_code = get_tree().change_scene("res://MainMenu.tscn")
		if error_code:
			print("Error: Fatal, unable to switch to main menu")
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
		"experience_total": experience_total,
		"experience_required": experience_requred,
		"experience_in_level": experience_in_level,
		"level": level,
		"total_crit_chance": total_crit_chance,
		"crit_chance": crit_chance,
		"crit_percent": crit_percent
	}
	return save_dict


func _on_RegenTimer_timeout():
	if !is_dead and current_health < max_health:
		current_health = min(current_health * regen_percent, max_health)
		emit_signal("update_health", current_health, max_health)
		

