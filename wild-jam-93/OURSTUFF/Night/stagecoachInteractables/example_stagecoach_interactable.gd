class_name StagecoachInteractable extends Node2D

#example stagecoach interactable
#these would spawn on the map during night gameplay

var dispatchDescription := ""
var dispatchIcon = "" #path of icon
var dispatchTitle = "" #title of interactable panel

var bounty: Bounty
var interactingStagecoach: StageCoach

func canInteract(stagecoach: StageCoach): #check data and return true if all requirments are met 
	return true

func getInteractableData():
	return {
		"dispatchDescription": dispatchDescription,
		"dispatchIcon": dispatchIcon,
		"dispatchTitle": dispatchTitle
	} # this returns a dictionary of relevent data, like how long it takes to inteact, chance to take damage etc

func stagecoachInteractStart(stagecoach: StageCoach): # the result of a stagecoach interacting
	pass #input stage coach, get array of hunters, this would decide how interaction would go like length of time or fail chance

func stagecoachInteractComplete(): # called when stagecoach finishes interaciton timer
	pass 

func stopDecayTimer(): #called when a dispatch happens, other wise you can dispactch a coach to a interactable that becomes null
	pass
