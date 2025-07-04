extends TextureRect

@export var prato = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hand_node = $"../hand"

var aberto = false

func _on_mouse_entered() -> void:
	if hand_node and hand_node.is_dragging_global and hand_node.current_dragged_card.is_played:
		aberto = true
		print("Carta em drag sobre o decartes!")
		animation_player.play("abrir_boca") 


func _on_mouse_exited() -> void:
	if aberto:
		aberto = false
		print("Carta saiu de cima do decartes.")
		animation_player.play("fechar_boca")
