@tool
extends Node2D


@export var inner_index: int = 0
@export var outer_index_1: int = 0
@export var outer_index_2: int = 0


@onready var inner_sticker: Polygon2D = $InnerSticker
@onready var outer_sticker_1: Polygon2D = $OuterSticker1
@onready var outer_sticker_2: Polygon2D = $OuterSticker2

@onready var colors: Node = $Colors


func _ready() -> void:
	color_stickers()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		color_stickers()


func color_stickers() -> void:
	inner_sticker.color = colors.get_inner_color(inner_index)
	outer_sticker_1.color = colors.get_outer_color(outer_index_1)
	outer_sticker_2.color = colors.get_outer_color(outer_index_2)


func flip_internal() -> void:
	inner_index = 0 if inner_index == 1 else 1
	var temp := outer_index_1
	outer_index_1 = outer_index_2
	outer_index_2 = temp


func flip() -> void:
	flip_internal()
	color_stickers()
