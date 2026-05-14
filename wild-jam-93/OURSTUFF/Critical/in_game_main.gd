extends Node
#this script is in charge of variables that carryover from day to night
#stuff like money, upgrades, bounty hunters etc
#also controls loading and unloading day and night scenes


var money := 0
var day := 0

var dayScene
var nightScene = preload("res://OURSTUFF/Night/in_game_night_main.tscn")
const devHunterIcon = "res://OURSTUFF/resources/devBountyHunter.png"
var current_night_scene


#we shouldnt ever have to delete specific instances form theses arrays
#if a hunter dies leave them in the array but set is dead to true
var hunters: Array[Hunter]
var stageCoaches = []

func _ready() -> void:
	stageCoaches = [StageCoach.new(), StageCoach.new(), StageCoach.new()]
	
	for i in 10:
		var hunter = Hunter.new(devHunterIcon)
		hunters.append(hunter)
		#night_ui.add_hunter(hunter)

	#stageCoaches[0].hunters = [Hunter.new(devHunterIcon)]
	#stageCoaches[1].hunters = [Hunter.new(devHunterIcon), Hunter.new(devHunterIcon)]
	#stageCoaches[2].hunters = [Hunter.new(devHunterIcon), Hunter.new(devHunterIcon), Hunter.new(devHunterIcon)]
	#for i in 2:
		#hunters.append(Hunter.new(devHunterIcon))
	loadNight()

func addMoney(value: int): # use negative int for subtractinon
	money += value
	current_night_scene.night_ui.update_money(money)

func getMoney():
	return money

func loadDay():
	pass

func loadNight():
	pass
	current_night_scene = nightScene.instantiate()
	#send data/ call instatiation function
	
	print(stageCoaches[2].hunters)
	add_child(current_night_scene)
	current_night_scene.spawnStagecoaches(stageCoaches)
	current_night_scene.set_hunters(hunters as Array[Hunter])

func getCoaches():
	return stageCoaches

func getHunters():
	return hunters
