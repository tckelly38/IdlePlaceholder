extends KinematicBody2D

var health = 100
var attack_damage = 10
var timer = Timer.new()
const totalCritChance = 100
var critChance = 75
var critPercent = 1.5


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemies = get_tree().get_nodes_in_group("enemies")
var colliding_enemies = []
var is_hurt = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_total_attack_dam():
	randomize()
	if(randi() % totalCritChance >= critChance):
		return [attack_damage * critPercent, true]
	return [attack_damage, false]
	
func give_damage():
	$AnimationPlayer.play("shoot")
	var best_target = null
	for enemy in enemies:
		if best_target == null:
			best_target = enemy
		elif (position.x + enemy.position.x) < (position.x + enemy.position.x):
			best_target = enemy
	if is_instance_valid(best_target):
		var results = get_total_attack_dam()
		best_target.hit(results[0], results[1])
		
func _input(event):
	if Input.is_action_pressed("my_attack"):
		give_damage()
		

func take_damage(enemies):
	for enemy in enemies: 
		timer.connect("timeout", self, "get_hit")
		timer.wait_time = enemy.hit_rate
		timer.one_shot = true
		add_child(timer)
		$AnimationPlayer.play("hit")
		health -= enemy.hit_damage
		timer.start()
		

func get_hit(enemy):
	pass

func _physics_process(delta):
	if(timer.time_left == 0 and colliding_enemies.size() > 0):
		take_damage(colliding_enemies)
	if health <= 0:
		$AnimationPlayer.play("death")
		

func _on_collision_Wall_body_entered(body):
	colliding_enemies.push_front(body)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().change_scene("res://MainMenu.tscn")
	else:
		$AnimationPlayer.play("idle")

		

