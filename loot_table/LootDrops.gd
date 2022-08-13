extends Resource
class_name LootDropResource

export(Array, Resource) var LootTable
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_reward():
	rng.randomize()
	var target = rng.randf()
	var sum = 0.0
	
	for item in LootTable:
		sum += item.drop_chance
		if(target <= sum):
			return item
	
	return null
# Called when the node enters the scene tree for the first time.
func _init():
	load_loot_drops()

func load_json_file(path):
	var file = File.new()
	if not file.file_exists(path):
		print("ERROR: " + path + " does not exist")
		file.close()
		return
		
	file.open(path, File.READ)
	var text  = file.get_as_text()
	file.close()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	
	return obj
	
func load_loot_drops():
	var loot_table = load_json_file("res://Databases/LootDrops.json")
	for loot in loot_table:
		var item := LootItem.new(loot, loot_table[loot]["Cost in Tries"], loot_table[loot]["Risk"], loot_table[loot]["Drop Chance"])
		LootTable.append(item)
	#print(loot_table["armor"]["Risk"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
