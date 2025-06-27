extends Control
@onready var margin_container_content: MarginContainer = %MarginContainerContent


func _on_button_back_pressed() -> void:
	self.visible = false
	margin_container_content.visible = true
	
