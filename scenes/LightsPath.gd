extends Node2D

var lights := Array()

signal ligth_path_off()

func _ready():
  var children = get_children()
  for child in children:
    child.turned_off.connect(_on_light_off)


func turn_on():
  lights.clear()
  var children = get_children()
  for child in children:
    lights.append(child)
    child.visible = false
  children.reverse()
  children.pop_front()
  for child in children:
    lights.append(child)
  _turn_on_next_light()


func _turn_on_next_light():
  if lights.is_empty():
    ligth_path_off.emit()
    return
  var next_light = lights.pop_front()
  next_light.turn_on()


func _on_light_off():
  _turn_on_next_light()
