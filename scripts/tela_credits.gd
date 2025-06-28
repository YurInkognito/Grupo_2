extends Control
@onready var margin_container_content: MarginContainer = %MarginContainerContent
@onready var texture_rect_3: TextureRect = $"../TextureRect3"

func _on_button_back_pressed() -> void:
	self.visible = false
	texture_rect_3.visible = true
	
