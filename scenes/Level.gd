extends Node2D

@onready var life_bar = %LifeBar
@onready var player: Player = %Player
@onready var map = %Map
@onready var oscillo_layer = %OscilloLayer
@onready var oscillo = %Oscillo
@onready var gui = %GUI

var _spectres_on_player : Array[Spectre] = []

func _ready():
  life_bar.max_value = player.max_life
  life_bar.value = player.life


func _process(delta: float):
  var damage := 0.0
  for spectre in _spectres_on_player:
    damage += spectre.damage
  if damage != 0.0:
    player.life -= damage * delta


func _on_display_oscillo(context: LightsGroup, correct_values: Array, values: Array):
  # call on next frame
  get_tree().process_frame.connect(func():
      context.oscillo_cpu.timer_changed.connect(oscillo._on_timer_changed)
      oscillo.init(context, correct_values, values)
      oscillo_layer.visible = true
      oscillo.visible = true
      gui.visible = false
  , CONNECT_ONE_SHOT)


func _on_oscillo_out(context: Node2D, ok: bool, values: Array):
  # call on next frame
  get_tree().process_frame.connect(func():
      var lights_group := context as LightsGroup
      if lights_group != null:
        lights_group.oscillo_cpu.values = values
        lights_group.oscillo_cpu.timer_changed.disconnect(oscillo._on_timer_changed)
        if ok:
          lights_group.oscillo_ok()
      oscillo_layer.visible = false
      oscillo.visible = false
      gui.visible = true
  , CONNECT_ONE_SHOT)


func _on_spectre_body_entered(spectre: Spectre, _player: Player):
  if not _spectres_on_player.has(spectre):
    _spectres_on_player.append(spectre)


func _on_spectre_body_exited(spectre: Spectre, _player: Player):
  _spectres_on_player.erase(spectre)


func _on_player_life_changed(life):
  life_bar.value = life


func _on_player_dead():
  print("dead")
