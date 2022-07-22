extends Node2D

const Enemy = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_node("SlimeEnemyTimer")
	timer.set_wait_time(get_node("enemy").spawnRate)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

	
func _on_Back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _process(delta):
	pass



func _on_SlimeEnemyTimer_timeout():
	var player = get_node("player")
	var e = Enemy.instance()
	var pos = player.position
	pos.y += rand_range(get_viewport().size.y / - 2 + 10, get_viewport().size.y / 2 - 10)
	pos.x += get_viewport().size.x - 20
	e.position = pos
	add_child(e)

