extends Control

func _ready() -> void:
	pause_game()
func _on_button_back_pressed() -> void:
		unpause_game()
		self.queue_free()

func pause_game():
	get_parent().get_tree().paused = true

func unpause_game():
	get_parent().get_tree().paused = false
