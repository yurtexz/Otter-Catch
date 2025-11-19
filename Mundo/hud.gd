extends Control

@onready var fish_label: Label = $FishLabel
var fish_count: int = 0

func set_fish_count(value: int) -> void:
	fish_count = value
	fish_label.text = str(fish_count)
