extends Node
#this script is in charge of variables that carryover from day to night
#stuff like money, upgrades, bounty hunters etc
#also controls loading and unloading day and night scenes


var money := 0
var day := 0

var dayScene
var nightScene = preload("res://OURSTUFF/Night/in_game_night_main.tscn")
const devHunterIcon = "res://OURSTUFF/resources/devBountyHunter.png"

#we shouldnt ever have to delete specific instances form theses arrays
#if a hunter dies leave them in the array but set is dead to true
var hunters = []
var stageCoaches = []

func _ready() -> void:
	stageCoaches = [StageCoach.new(), StageCoach.new(), StageCoach.new()]
	stageCoaches[0].hunters = [Hunter.new(devHunterIcon)]
	stageCoaches[1].hunters = [Hunter.new(devHunterIcon), Hunter.new(devHunterIcon)]
	stageCoaches[2].hunters = [Hunter.new(devHunterIcon), Hunter.new(devHunterIcon), Hunter.new(devHunterIcon)]
	for i in 2:
		hunters.append(Hunter.new(devHunterIcon))
	loadNight()

func addMoney(value: int): # use negative int for subtractinon
	money += value
	print(money)

func getMoney():
	return money

func loadDay():
	pass

func loadNight():
	pass
	var temp = nightScene.instantiate()
	#send data/ call instatiation function
	temp.spawnStagecoaches(stageCoaches)
	print(stageCoaches[2].hunters)
	add_child(temp)

func getCoaches():
	return stageCoaches

func getHunters():
	return hunters
