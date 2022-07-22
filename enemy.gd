extends KinematicBody2D
var hit_damage = 10
var hit_rate = 1
var health = 100
var speed = 0.25
const spawnRate = 2.0
var needSpawn = true
onready var timer = get_node("Timer")

var floating_text = preload("res://FloatingPoint.tscn")

onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if $Sprite.visible:
		var direction = (player.get_position().x - position.x)
		var motion = direction * speed * delta
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
	timer = Timer.new()
	
	timer.set_wait_time(spawnRate)
	timer.set_one_shot(false)

	add_child(timer)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	needSpawn = true
