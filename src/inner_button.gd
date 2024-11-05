@tool
extends Node2D


signal inner_pressed


@export var inner_index: int = 0


@onready var sticker: Polygon2D = $Sticker
@onready var highlight: Polygon2D = $Highlight
@onready var colors: Node = $Colors


func _ready() -> void:
	color_sticker()


func flip_internal() -> void:
	inner_index = 0 if inner_index == 1 else 1


func color_sticker() -> void:
	sticker.color = colors.get_inner_color(inner_index)


func _input(event: InputEvent) -> void:
	if not highlight.visible:
		return

	if event is InputEventMouseButton:
		var me: InputEventMouseButton = event
		if me.is_pressed() and me.button_index == MOUSE_BUTTON_LEFT:
			_on_pressed()
			get_viewport().set_input_as_handled()


func _on_area_2d_mouse_entered() -> void:
	highlight.show()


func _on_area_2d_mouse_exited() -> void:
	highlight.hide()


func _on_pressed() -> void:
	inner_pressed.emit()
