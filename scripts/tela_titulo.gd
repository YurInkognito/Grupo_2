extends Control


func _on_botao_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
	
func _on_botao_sair_pressed() -> void:
	get_tree().quit()
