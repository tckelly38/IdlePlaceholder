extends Resource
class_name PlayerBank

export(int) var current_gold
const gold_value = 1

signal gold_amount_changed

	
func add_gold():
	current_gold += gold_value
	emit_signal("gold_amount_changed", current_gold)
	
func get_total():
	return current_gold
