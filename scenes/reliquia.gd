extends Node2D

@export var card_data: CartaData


func set_relic(data: CartaData):
	$TextureRect.texture = data.sprite
	$TextureRect.tooltip_text = data.desc
