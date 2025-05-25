extends Control

func _ready() -> void:
	pause_game()
func _on_button_back_pressed() -> void:
	if get_parent().name == "TelaTitulo":
		print("Back to Menu")
		get_parent().get_child(0).visible = true
		unpause_game()
		self.queue_free()
	else:
		print("Baco to Game")
		unpause_game()
		self.queue_free()

func pause_game():
	get_parent().get_tree().paused = true

func unpause_game():
	get_parent().get_tree().paused = false
