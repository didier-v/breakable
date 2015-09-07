extends Node

# GodotNotificationCenter
# https://github.com/didier-v/GodotNotificationCenter
# Written by Didier Vandekerckhove
# licence: MIT

var notifications

func _ready():
	notifications = {};
	pass
	
func post_notification(notificationName,notificationData):
	if notifications.has(notificationName):
		var currentObservers=notifications[notificationName].observers
		for i in currentObservers:
			var anObserver =  currentObservers[i]
			if anObserver.object.has_method(anObserver.action):
				anObserver.object.call(anObserver.action,anObserver.object,notificationName,notificationData)

func add_observer(observer,notificationName,action):
	if not notifications.has(notificationName):
		notifications[notificationName]={
			"observers":{}
		}
	var currentObservers=notifications[notificationName].observers
	currentObservers[observer.get_instance_ID()]={
		"object":observer,
		"action":action
	}

func remove_observer(observer, notificationName):
	if notifications.has(notificationName):
		var currentObservers=notifications[notificationName].observers
		if currentObservers.has(observer.get_instance_ID()):
			currentObservers.erase(observer.get_instance_ID())

