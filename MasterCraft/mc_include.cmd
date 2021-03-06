#MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
#v 0.1.6
#
# Script Usage: .mastercraft								--to only do one work order
#				.mastercraft <no. of orders>				--to perform more than one
#				.mastercraft <no. of orders> <difficulty>	--to quickly change your order difficulty because of new skill range (not added yet)
#
# 	Welcome to the include file!
#
#	This is where you set up your character's crafting profile. Since there are many different crafts and some people like to do orders from many,
#	the personal variables are set by which type of society you're in so you don't have to edit them so often. Each character can have its own
#	crafting profile, so you may change these variables to your own personal liking for each character you use this script with.
#	
#	Here's a breakdown of each variable:																		Used In:
#	forging.storage		--Container for forging (tools, deeds, spare parts, etc.) 								pound, grind
#	outfitting.storage	--Container for outfitting equipment (tools, deeds, spare parts, etc.)					sew, knit
#	engineering.storage	--Container for engineering equipment (tools, deeds, spare parts, etc.)					carve
#	remnant.storage		--Container for putting failed items, materials too small to make stuff with.			mastercraft
#	work.material		--The stocked material type for orders. Be specific (ie. bronze-alloy, gargoyle-hide.)	mastercraft
#	discipline		-- "blacksmith, armor, weapon, tailor, carving"
#
#	These variables must be set -to the letter-. Yes, this means they are case-sensitive:
#	repair			--"on" or "off" ONLY. Set if you want to repair your tools. If repair is on and auto-repair is off it will use the Engineering tool repair. Only works in Crossing right now.						mastercraft
#	auto.repair		--"on" or "off" ONLY. Set if you want to repair your own metal tools (must have techs.)			mastercraft
#	reclaim.metal		--"on" or "off" ONLY. Set if you have flux and wish to reclaim failed items.				mastercraft
#	deed.order		--"on" or "off" ONLY. Set if your products are heavy(ie. armor, stone furniture.)			mastercraft
#	MC.Mark			--"on" or "off" ONLY. Set if you have a maker's mark you wish to use.						mastercraft, pound, grind, sew, carve, knit
#	discipline		--"weapon", "armor", "blacksmith", "tailor", "carving" ONLY.								mastercraft
#	work.difficulty		--"easy", "challenging", "hard" ONLY. Used for asking for work orders.						mastercraft
#	order.pref		--"cloth", "leather", "knitted", "stone", "bone" ONLY. Determines the orders you keep.		mastercraft
#	get.coin		--"on" or "off ONLY. Set if you want to withdraw coins to repurchase supplies. Only works if teller is in the same map
#	reorder			--"on" or "off ONLY. Set if you want to buy new material if you do not have enough
#	SmallOrders		--"1" or "0" ONLY. 1 is on 0 is off. Set if you want to only take forging work orders at or under 5 volume
#
#	Be sure to complete your character's crafting profile before running any of the included scripts. There are some things scripting
#	cannot do for you, such as make personal decisions.
#	
#	Each script can be run completely standalone from Mastercraft if you want to create multiple items or just individual orders. Using them
#	as such will require you to be responsible for your own material management and quality control.
#
# Happy Crafting!
gosub location.vars
gosub check.location

eval forging.storage tolower($MC_FORGING.STORAGE)
eval outfitting.storage tolower($MC_OUTFITTING.STORAGE)
eval engineering.storage tolower($MC_ENGINEERING.STORAGE)
eval alchemy.storage tolower($MC_ALCHEMY.STORAGE)
eval remnant.storage tolower($MC_REMNANT.STORAGE)
put #var MC.Mark off
eval repair tolower($MC_REPAIR)
eval auto.repair tolower($MC_AUTO.REPAIR)
eval get.coin tolower($MC_GET.COIN)
eval reorder tolower($MC_REORDER)
put #unvar repair.room
put #trigger {completely understand all facets of the design\.$} {#var MC_DIFFICULTY 6}
put #trigger {comprehend all but several minor details in the text\.$} {#var MC_DIFFICULTY 5}
put #trigger {confidently discern most of the design's minutiae\.$} {#var MC_DIFFICULTY 4}
put #trigger {interpret many of the design's finer points\.$} {#var MC_DIFFICULTY 3}
put #trigger {abosrb a hadful of the design's finer point\.$} {#var MC_DIFFICULTY 2}
put #trigger {fail to grasp all but the simplest diagrams on the page\.$} {#var MC_DIFFICULTY 1}
put #trigger {quickly realize the design is far beyond your abilities\.$} {#var MC_DIFFICULTY 0}


###########################################################################
### Character Profiles. Please edit these for your character(s). 
###########################################################################

#Forging settings
if "%society.type" = "Forging" then
	{
	 eval discipline tolower($MC_FORGING.DISCIPLINE)
	 if !matchre("%discipline", "blacksmith|weapon|armor") then goto discfail
	 eval work.difficulty tolower($MC_FORGING.DIFFICULTY)
	 eval work.material tolower($MC_FORGING.MATERIAL)
	 eval order.pref tolower(ingot)
	 eval main.storage tolower(%forging.storage)
	 put #var MC.Mark off
	 eval deed.order tolower($MC_FORGING.DEED)
	}
#Outfitting settings
if "%society.type" = "Outfitting" then
	{
	 eval discipline tolower($MC_OUT.DISCIPLINE)
	 if !matchre("%discipline", "tailor") then goto discfail
	 eval work.difficulty tolower($MC_OUT.DIFFICULTY)
	 eval work.material tolower($MC_OUT.MATERIAL)
	 eval order.pref tolower($MC_OUT.PREF)
	 eval main.storage tolower(%outfitting.storage)
	 put #var MC.Mark off
	 eval deed.order tolower($MC_OUT.DEED)
	}
#Engineering settings
if "%society.type" = "Engineering" then
	{
	 eval discipline tolower($MC_ENG.DISCIPLINE)
	 if !matchre("%discipline", "carving|shaping|tinkering") then goto discfail
	 eval work.difficulty tolower($MC_ENG.DIFFICULTY)
	 eval work.material tolower($MC_ENG.MATERIAL)
	 eval deed.size
	 eval order.pref tolower($MC_ENG.PREF)
	 eval main.storage tolower(%engineering.storage)
	 put #var MC.Mark off
	 eval deed.order tolower($MC_ENG.DEED)
	}
#Alchemy Settings
if "%society.type" = "Alchemy" then
	{
	 eval discipline tolower($MC_ALC.DISCIPLINE)
	 if !matchre("%discipline", "remed") then goto discfail
	 eval work.difficulty tolower($MC_ALC.DIFFICULTY)
	 var work.material
	 var deed.size
	 var order.pref 
	 eval main.storage tolower(%alchemy.storage)
	 put #var MC.Mark off
	 var deed.order 
	}
goto endinclude

discfail:
	put #echo %discipline is not a valid %society.type Discipline. Please try again.
	exit


####################################################################################################
### End of Character Profiles. The following is necessary for location settings and script operation. 
####################################################################################################


location.vars:
	#Haven Forging
	 var HF.room.list 442|441|443|405|404|398|402|403|409|408|399|406|407|400|410|411|401
	 var HF.master.room 398|399|400|401
	 var HF.work.room 405|409|403|407|411
	 var HF.smelt.room 402|404|406|408|410
	 var HF.grind.room %HF.work.room 
	#Haven Outfitting
	 var HO.room.list 448|450|449|451|458|459|455|452|453|454|456|457|460
	 var HO.master.room 448|449|450|451|452|453|454
	 var HO.work.room 458|459|460|455|456|457
	 var HO.wheel.room 458|459|460
	 var HO.loom.room 455|456|457
	#Haven Engineering
	 var HE.room.list 461|462|463|464|465|466|467|468|469
	 var HE.master.room 462|461|463|464|465|466
	 var HE.work.room 467|468|469|464|462
	#Haven Alchemy
	 var HA.tools.room 470
     var HA.supplies.room 472
     var HA.books.room 482
     var HA.work.room 479|478|477|475|474|473|481|476
     var HA.room.list 470|471|473|474|475|481|472|476|479|478|477|480|482
     var HA.master.room 470|471|473|474|475|481|472|476|479|478|477|480|482
	#Crossing Forging
	 var CF.room.list 903|865|962|961|960|902|905|904|906|963|907|908|909
	 var CF.master.room 903|865|962|961|960|902|905|904|906|963|907|908|909
	 var CF.smelt.room 903|904|960|961
	 var CF.work.room 907|908|909|962|963
	 var CF.grind.room 962|963
	#Crossing Outfitting
	 var CO.room.list 873|910|911|912|913|914|915|916|917|918|919|920|921|922|923|924
	 var CO.master.room 873|910|911|912|913|914|915|916
	 var CO.work.room 917|918
	 var CO.wheel.room 922|923|924
	 var CO.loom.room 919|920|921
	#Crossing Engineering
	 var CE.room.list 851|925|874|926|927|928|929|930
	 var CE.master.room 851|925|874|926|927|928|929|930
	 var CE.work.room 928|929|930
	#Crossing Alchemy
	 var CA.room.list 898|931|932|933|934
	 var CA.master.room 898|931|932|933|934
	 var CA.work.room 898|931|932|933|934
	#Lava Forge
	 var LvF.room.list 774|777|776|775|778|782|779|784|780|786|781|783|785
	 var LvF.master.room 775|778|782|779|784|780|786
	 var LvF.smelt.room 778|779|780
	 var LvF.work.room 781|783|785
	 var LvF.grind.room 782|786|784
	#Leth Premie Forge
	 var LPF.room.list 248|238|239|240|241|242|243|244|245|246|247|253|252|251|250|249|237
	 var LPF.master.room 248|238|239|240|241|242|243|244|245|246|247|253|252
	 var LPF.work.room 251|250|249
	 var LPF.grind.room 252|253|247
	#Ratha Forging
	 var RF.room.list 818|819|820|821|822|823|824|825|826|827|828|829|830|831|832
	 var RF.master.room 819|820|821|822|823|824|825|826|827|828|829|830|831|832
	 var RF.work.room 830|831|832
	 var RF.grind.room 821|822|823
	#Ratha Outfitting
	var RO.room.list 850|851|852|846|843|845|847|848|849|844|841|839|840|842
	var RO.master.room 844|841|839|840|842
	var RO.work.room 845|846
	var RO.wheel.room 847|848|849
	var RO.loom.room 850|851|852
	#Shard Forging
	 var SF.room.list 644|661|645|648|648|649|650|651|652|653|654|655|656|657|658|659|660|646
	 var SF.master.room 644|645|649|650|653|654|655|658|646|661
	 var SF.work.room 648|652|657|660
	 var SF.grind.room %SF.work.room
	 #Shard Alchemy
	 var SA.room.list 700|701|702|703|704|705
	 var SA.master.room 700|701|702|703|704|705
	 var SA.work.room 700|701|702|703|704|705
	#Hibarnhivdar Forging
	 var HibF.room.list 407|408|416|417|418|419|409|410|411|412|413|414|415
 	 var HibF.master.room 407|408|416|417|418|419|409|410|411|412|413|414|415
	 var HibF.work.room 416|417|418|419
	 var HibF.grind.room 418|419
	 
	#Mer'Kresh Forging
	 var MKF.room.list 334|335|336|337|338|339|340|341|342|343|344|345|346|347|348
 	 var MKF.master.room 334|335|336|337|338
	 var MKF.work.room 344|345|346|347|348
	 var MKF.grind.room %MKF.work.room
	 
	 #Fang Cove Engineering
	 var FE.room.list 206|207|208|209|210|220|221
	 var FE.master.room 206|207|208|209|210
	 var FE.work.room 220|221
	 
	 #Fang Cove Forging
	 var FF.room.list 196|197|198|199|200|201|202|203|204|215|216|217|218|219
	 var FF.master.room 196|197|198|199|200|201|202|203|204
	 var FF.work.room 217|219
	 var FF.grind.room 217|219
	 var FF.smelt.room 216|218

	 #Fang Cove Outfitting
	 var FO.room.list 183|184|185|186|187|188|189|211|212|213|214
	 var FO.master.room 183|184|185|186|187|188|189
	 var FO.work.room 211|212|213|214	 
	 
	 #Fang Cove Alchemy
	 var FA.room.list 190|191|192|193|194|195
	 var FA.master.room 190|191|192|193|194|195
	 var FA.work.room 190|191
	
	#Repair Locations
	 var crossing.repair.room Rangu
	 var crossing.repair Rangu
	 var haven.repair.room 398
	 var haven.repair clerk

	 var Master.Found 0
	 action instant var Master.Found 1 when ^Heavily muscled for an Elf, Fereldrin|^Yalda is a plump Dwarf|^Standing at an imposing height, the Gor'Tog surveys |^Serric is a muscular Human|^Juln is a muscular Dwarf|^Hagim is slight Gnome man|^Paarupensteen is a balding plump Halfling|^Milline is a tall Elothean woman|^Talia is a honey-brown haired Human|^This well-muscled Elf stands taller than 
	 return

check.location: 
	#gosub Crossing.%current.lore
	#return
	var society none
	if $zoneid = 30 && matchre("%HF.room.list", "$roomid") then var society Haven.Forging
	if $zoneid = 30 && matchre("%HO.room.list", "$roomid") then var society Haven.Outfitting
	if $zoneid = 30 && matchre("%HE.room.list", "$roomid") then var society Haven.Engineering
	if $zoneid = 30 && matchre("%HA.room.list", "$roomid") then var society Haven.Alchemy
	if $zoneid = 1 && matchre("%CF.room.list", "$roomid") then var society Crossing.Forging
	if $zoneid = 1 && matchre("%CO.room.list", "$roomid") then var society Crossing.Outfitting
	if $zoneid = 1 && matchre("%CE.room.list", "$roomid") then var society Crossing.Engineering
	if $zoneid = 1 && matchre("%CA.room.list", "$roomid") then var society Crossing.Alchemy
	if $zoneid = 90 && matchre("%RF.room.list", "$roomid") then var society Ratha.Forging
	if $zoneid = 90 && matchre("%RO.room.list", "$roomid") then var society Ratha.Outfitting
	if $zoneid = 67 && matchre("%SF.room.list", "$roomid") then var society Shard.Forging
	if $zoneid = 67 && matchre("%SA.room.list", "$roomid") then var society Shard.Alchemy
	if $zoneid = 116 && matchre("%HibF.room.list", "$roomid") then var society Hib.Forging
	if $zoneid = 107 && matchre("%MKF.room.list", "$roomid") then var society MerKresh.Forging
	if $zoneid = 7 && matchre("%LvF.room.list", "$roomid") then var society Lava.Forge
	if $zoneid = 61 && matchre("%LPF.room.list", "$roomid") then var society Leth.Premie.Forge
	if $zoneid = 150 && matchre("%FE.room.list", "$roomid") then var society Fang.Engineering
	if $zoneid = 150 && matchre("%FF.room.list", "$roomid") then var society Fang.Forging
	if $zoneid = 150 && matchre("%FO.room.list", "$roomid") then var society Fang.Outfitting
	if $zoneid = 150 && matchre("%FA.room.list", "$roomid") then var society Fang.Alchemy
	pause 1
	gosub %society
	return

Haven.Forging:
var master Fereldrin
put #tvar master.room %HF.master.room
put #tvar grind.room %HF.grind.room
put #tvar work.room %HF.work.room
put #tvar smelt.room %HF.smelt.room
put #tvar deed.room 442
put #tvar supply.room 400
put #tvar part.room 399
put #tvar tool.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Forging
return

Haven.Outfitting:
var master Hagim
put #tvar master.room %HO.master.room
put #tvar work.room %HO.work.room
put #tvar supply.room 450
put #tvar part.room 450
#order parts
put #tvar tool.room 451
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Outfitting
return

Haven.Engineering:
var master Paarupensteen
put #tvar master.room %HE.master.room
put #tvar work.room %HE.work.room
put #tvar supply.room 465
put #tvar part.room 466
put #tvar tool.room 465
put #tvar ingot.buy 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Engineering
return

Haven.Alchemy:
var master Carmifex
put #tvar master.room %HA.master.room
put #tvar work.room %HA.work.room
put #tvar supply.room 472
put #tvar tool.room 470
put #tvar repair.room %haven.repair.room
var repair.clerk %haven.repair
var society.type Alchemy
return

Crossing.Forging:
var master Yalda
put #tvar master.room %CF.master.room
put #tvar grind.room %CF.grind.room
put #tvar work.room %CF.work.room
put #tvar smelt.room %CF.smelt.room
put #tvar deed.room 906
put #tvar supply.room 906
put #tvar part.room 905
put #tvar tool.room 905
put #tvar repair.room %crossing.repair.room
var repair.clerk %crossing.repair
var society.type Forging
return 

Crossing.Outfitting:
var master Milline
put #tvar master.room %CO.master.room
put #tvar work.room %CO.work.room
put #tvar supply.room 914
put #tvar part.room 914
#order parts
put #tvar tool.room 913
put #tvar repair.room %crossing.repair.room
var repair.clerk %crossing.repair
var society.type Outfitting
return

Crossing.Engineering:
var master Talia
put #tvar master.room %CE.master.room
put #tvar work.room %CE.work.room
put #tvar supply.room 874
put #tvar part.room 851
put #tvar tool.room 851
put #tvar ingot.buy 906
put #tvar repair.room %crossing.repair.room
var repair.clerk %crossing.repair
var society.type Engineering
return

Crossing.Alchemy:
var master Lanshado
put #tvar master.room %CA.master.room
put #tvar work.room %CA.work.room
put #tvar supply.room 933
put #tvar tool.room 931
put #tvar repair.room %crossing.repair.room
var repair.clerk %crossing.repair
var society.type Alchemy
return

Lava.Forge:
var master Borneas
put #tvar master.room %LvF.master.room
put #tvar grind.room %LvF.grind.room
put #tvar work.room %LvF.work.room
put #tvar smelt.room %LvF.smelt.room
put #tvar deed.room 775
put #tvar supply.room 775
put #tvar part.room 777
put #tvar tool.room 777
var society.type Forging
return

Leth.Premie.Forge:
var master None
put #tvar master.room %LPF.master.room
put #tvar grind.room %LPF.grind.room
put #tvar work.room %LPF.work.room
put #tvar deed.room 248
put #tvar supply.room 248
put #tvar part.room 248
put #tvar tool.room 238
var society.type Forging
return

Ratha.Forging:
var master Grimbly
put #tvar master.room %RF.master.room
put #tvar grind.room %RF.grind.room
put #tvar work.room %RF.work.room
put #tvar deed.room 829
put #tvar supply.room 829
put #tvar part.room 819
put #tvar tool.room 819
var society.type Forging
return

Ratha.Outfitting:
var master Master
put #tvar master.room %RO.master.room
put #tvar work.room %RO.work.room
put #tvar supply.room 844
put #tvar part.room 844
put #tvar tool.room 842
var society.type Outfitting
return

Shard.Forging:
var master Serric
put #tvar master.room %SF.master.room
put #tvar grind.room %SF.grind.room
put #tvar work.room %SF.work.room
put #tvar deed.room 661
put #tvar supply.room 658
put #tvar part.room 653
put #tvar tool.room 653
var society.type Forging
return

Shard.Alchemy:
var master Benzia
put #tvar master.room %SA.master.room
put #tvar work.room %SA.work.room
put #tvar supply.room 701
put #tvar tool.room 703
var society.type Alchemy
return

Hib.Forging:
var master Juln
put #tvar master.room %HibF.master.room
put #tvar grind.room %HibF.grind.room
put #tvar work.room %HibF.work.room
put #tvar deed.room 415
put #tvar supply.room 415
put #tvar part.room 413
put #tvar tool.room 413
var society.type Forging
return

MerKresh.Forging:
var master Kapric
put #tvar master.room %MKF.master.room
put #tvar grind.room %MKF.grind.room
put #tvar work.room %MKF.work.room
put #tvar deed.room 336
put #tvar supply.room 336
put #tvar part.room 337
put #tvar tool.room 337
var society.type Forging
return

Fang.Engineering:
var master Brogir
put #tvar master.room %FE.master.room
put #tvar work.room %FE.work.room
put #tvar supply.room 208
put #tvar part.room 208
put #tvar tool.room 209
put #tvar ingot.buy 200
var society.type Engineering
return

Fang.Forging:
var master Phahoe
put #tvar master.room %FF.master.room
put #tvar grind.room %FF.grind.room
put #tvar work.room %FF.work.room
put #tvar deed.room 203
put #tvar supply.room 200
put #tvar part.room 215
put #tvar tool.room 215
put #tvar smelt.room 216
var society.type Forging
return

Fang.Outfitting:
var master Varcenti
put #tvar master.room %FO.master.room
put #tvar work.room %FO.work.room
put #tvar supply.room 187
put #tvar part.room 187
put #tvar tool.room 186
var society.type Outfitting
return

Fang.Alchemy:
var master Swetyne
put #tvar master.room %FA.master.room
put #tvar work.room %FA.work.room
put #tvar supply.room 194
put #tvar tool.room 193
var society.type Alchemy
return

none:
if matchre("$scriptlist", "mastercraft") then 
	{
	put #echo You are not in a valid society
	exit
	}
return


find.room:
	if "%discipline" = "remed" then return
	var find.room $1
	 if ((matchre("%find.room", "$roomid")) && matchre("$MC_FRIENDLIST", "(?:$roomplayers)|(^$)")) then return
	 var temp 0
	 eval temp.max count("%find.room","|")
find.room2:
	 gosub automove %find.room(%temp)
 	 if ((matchre("%find.room", "\b$roomid\b")) && matchre("$MC_FRIENDLIST", "(?:$roomplayers)|(^$)")) then
		{
		unvar temp
		unvar temp.max
		return
		}
	 math temp add 1
	 if %temp > %temp.max then gosub find.room.wait
	 goto find.room2
	return
	
find.room.wait:
	 var temp 0
	 gosub automove $tool.room
	 echo *** All workrooms occupied, waiting 90 seconds before trying again...
	 put #parse All workrooms occupied
	 pause 90
	 return

find.master:
	 gosub check.location
	 var Master.Found 0
	 var temp 0
	 eval temp.max count("$master.room","|")
	 #pause 1
	 #send look %master
	 #pause 1
	 #if %Master.Found = 1 then
         if matchre("$roomobjs", "%master") then
	 {
	 unvar temp
	 unvar temp.max
	 return
	 }
find.master2:
	 pause 1
	 gosub automove $master.room(%temp)
	 #send look %master
	 #pause 1
	 #if %Master.Found = 1 then
         if matchre("$roomobjs", "%master") then
		{
		unvar temp
		unvar temp.max
		return
		}
	 math temp add 1
	 if %temp > %temp.max then
	{
	goto find.master
	 echo %master not found in any room specified. Check your master room list for this society!
	 exit
	}
	gosub find.master2
	return

automove:
	 if $roomid = 0 then return
	 var toroom $0
automovecont:
	 match automovecont2 Bonk! You smash your nose.
	 match return YOU HAVE ARRIVED
	 match automovecont1 YOU HAVE FAILED
	 put #goto %toroom
	 matchwait

automovecont1:
	 pause
	 put look
	 pause
	goto automovecont

automovecont2:
	 pause
	 if matchre("$scriptlist", "automapper") then send #script abort automapper
	 pause
	 return

mark:
	if $MC.Mark = "off" then return
	if $MC.Mark = "on" then
	{
	 send get my stamp
	 waitforre ^You get
	 send mark $MC.order.noun with my stamp
	 waitforre ^Roundtime
	 send stow my stamp
	 waitforre ^You put
	 return
	}
	return
	
verb:
	var verb $0
	goto verb.a
verb.p:
	pause 0.5
verb.a:
	match verb.p type ahead
	match verb.p ...wait
	matchre verb.d (You get|You put|You pick up|Get what\?|You count out|What were you|You move|You glance down|Just give it to me again if you want|You drop|Roundtime|STOW HELP|completely undamaged and does not need repair|cannot figure out how to do that|not damaged enough to warrant repair|bundle them with your logbook and then give|you just received a work order|You turn your book|You study|You scan|You notate|You hand|You slide|You place|You have no idea how to craft|The book is already turned|What were you referring|You realize you have items bundled with the logbook)
	matchre verb.d ^The clerk counts|Searching methodically|Perhaps you should be holding that|You find your jar|You close|You open|The (\S+) can only hold|The attendant|You measure out|You carefully break off|You may purchase|^You hand|"There isn't a scratch on that|"I don't repair those here\."|That is already|You are already holding|What were you referring
	matchre verb.s You need a free hand
	send %verb
	matchwait
verb.d:
    return
	
verb.s:
	send stow right
	send stow left
	return

anvilcheck:
	var anvilingot 0
	matchre clean ^The anvil already has|unfinished .+ (\S+)\.
	matchre return The anvil's surface looks clean
	matchre ingot On the.* anvil you see a %work.material ingot
	matchre manualclean On the.* anvil you see a 
	put look on anvil
	matchwait 2

	
clean:
	send clean anvil
	send clean anvil
	pause 0.5
	pause 0.5
	return

manualclean:
	send get ingot
	send drop ingot
	return
	
ingot:
	var anvilingot 1
	return
endinclude:
