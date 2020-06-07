/obj/map_metadata/art_of_the_deal
	ID = MAP_THE_ART_OF_THE_DEAL
	title = "The Art of the Deal"
	lobby_icon_state = "taotd"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall)
	respawn_delay = 3000
	is_singlefaction = TRUE
	no_winner ="The fighting is still going."
	songs = list(
		"Fortunate Son:1" = 'sound/music/fortunate_son.ogg',)
	faction_organization = list(
		CIVILIAN)

	roundend_condition_sides = list(
		list(CIVILIAN) = /area/caribbean/british/ship, //it isnt in the map so nobody wins by capture
		)
	age = "1994"
	ordinal_age = 8
	var/fac_nr = 3
	faction_distribution_coeffs = list(CIVILIAN = 1)
	battle_name = "the deal"
	mission_start_message = "<font size=4><b>4</b> corporations are fighting for control of the disks.<br>Please read the manual: http://civ13.com/wiki/index.php/The_Art_of_the_Deal</font>"
	var/winner_name = "Unknown"
	var/list/winner_ckeys = list()
	faction1 = CIVILIAN
	faction2 = PIRATES
	gamemode = "Negotiations"
	scores = list(
		"Rednikov Industries" = 0,
		"Giovanni Blu Stocks" = 0,
		"MacGreene Traders" = 0,
		"Goldstein Solutions" = 0,
		"Police" = 0,)
	required_players = 6

/obj/map_metadata/art_of_the_deal/New()
	..()
	spawn(3000)
		score()
	var/newnamea = list("Rednikov Industries" = list(230,230,230,null,0,"sun","#7F0000","#7F7F7F",0,0))
	var/newnameb = list("Giovanni Blu Stocks" = list(230,230,230,null,0,"sun","#00007F","#7F7F7F",0,0))
	var/newnamec = list("MacGreene Traders" = list(230,230,230,null,0,"sun","#007F00","#7F7F7F",0,0))
	var/newnamed = list("Goldstein Solutions" = list(230,230,230,null,0,"sun","#E5E500","#7F7F7F",0,0))
	var/newnamee = list("Police" = list(230,230,230,null,0,"star","#E5E500","#00007F",0,0))
	var/newnamef = list("Paramedics" = list(230,230,230,null,0,"cross","#7F0000","#FFFFFF",0,0))
	custom_civs += newnamea
	custom_civs += newnameb
	custom_civs += newnamec
	custom_civs += newnamed
	custom_civs += newnamee
	custom_civs += newnamef
	spawn(15000)
		spawn_disks(TRUE)
/obj/map_metadata/art_of_the_deal/job_enabled_specialcheck(var/datum/job/J)
	if (J.is_deal)
		. = TRUE
	else
		. = FALSE

/obj/map_metadata/art_of_the_deal/faction2_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)

/obj/map_metadata/art_of_the_deal/faction1_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 3000 || admin_ended_all_grace_periods)

/obj/map_metadata/art_of_the_deal/cross_message(faction)
	if (faction == CIVILIAN)
		return "<font size = 4><b>The round has started!</b> Players may now cross the invisible wall!</font>"
/obj/map_metadata/the_art_of_the_deal/proc/load_new_recipes() //bow ungas BTFO
	var/F3 = file("config/material_recipes_camp.txt")
	if (fexists(F3))
		craftlist_list = list()
		var/list/craftlist_temp = file2list(F3,"\n")
		for (var/i in craftlist_temp)
			if (findtext(i, ","))
				var/tmpi = replacetext(i, "RECIPE: ", "")
				var/list/current = splittext(tmpi, ",")
				craftlist_list += list(current)
				if (current.len != 13)
					world.log << "Error! Recipe [current[2]] has a length of [current.len] (should be 13)."

/obj/map_metadata/art_of_the_deal/proc/spawn_disks(repeat = FALSE)
	for(var/obj/structure/closet/safe/SF in world)
		if (SF.faction)
			switch(SF.faction)
				if ("Rednikov Industries")
					if (SF.opened)
						new/obj/item/weapon/disk/red(SF.loc)
						new/obj/item/weapon/disk/red/fake(SF.loc)
					else
						new/obj/item/weapon/disk/red(SF)
						new/obj/item/weapon/disk/red/fake(SF)
				if ("Giovanni Blu Stocks")
					if (SF.opened)
						new/obj/item/weapon/disk/blue(SF.loc)
						new/obj/item/weapon/disk/blue/fake(SF.loc)
					else
						new/obj/item/weapon/disk/red(SF)
						new/obj/item/weapon/disk/red/fake(SF)
				if ("MacGreene Traders")
					if (SF.opened)
						new/obj/item/weapon/disk/green(SF.loc)
						new/obj/item/weapon/disk/green/fake(SF.loc)
					else
						new/obj/item/weapon/disk/green(SF)
						new/obj/item/weapon/disk/green/fake(SF)
				if ("Goldstein Solutions")
					if (SF.opened)
						new/obj/item/weapon/disk/yellow(SF.loc)
						new/obj/item/weapon/disk/yellow/fake(SF.loc)
					else
						new/obj/item/weapon/disk/yellow(SF)
						new/obj/item/weapon/disk/yellow/fake(SF)
	if (repeat)
		spawn(12000)
			spawn_disks(repeat)
	world << "<font size=2 color ='yellow'>New disks have arrived at the vaults!</font>"

/obj/map_metadata/art_of_the_deal/proc/score()
	world << "<b><font color='yellow' size=3>Scores:</font></b>"
	for(var/obj/structure/closet/safe/SF in world)
		if (SF.faction)
			var/list/tlist = list(SF.faction,0)
			for(var/obj/item/I in SF)
//				if (istype(I, /obj/item/weapon/disk))
//					var/obj/item/weapon/disk/D = I
//					if (D.faction && D.faction != SF.faction)
//						tlist[2]+=500
				if (istype(I, /obj/item/stack/money))
					var/obj/item/stack/money/M = I
					tlist[2]+=M.amount*M.value/4
			tlist[2] += scores[SF.faction]
			world << "<big><font color='yellow' size=2>[tlist[1]]: [tlist[2]] points</font></big>"
//five-o scores
	var/list/tlist2 = list("Police",0)
	for(var/obj/item/I in get_area(/area/caribbean/prison/jail))
		if (istype(I, /obj/item/weapon/disk))
			var/obj/item/weapon/disk/D = I
			if (D.faction && !D.used)
				tlist2[2]+=300
		if (istype(I, /obj/item/stack/money))
			var/obj/item/stack/money/M = I
			tlist2[2]+=M.amount*M.value/4
	tlist2[2] += scores["Police"]
	world << "<big><font color='yellow' size=2>[tlist2[1]]: [tlist2[2]] points</font></big>"
	spawn(3000)
		score()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/vending/business_apparel
	name = "equipment rack"
	desc = "All the equipment you need for that special business meeting."
	icon_state = "apparel_german2"
	products = list(
		/obj/item/stack/medical/bruise_pack/gauze = 10,
		/obj/item/clothing/accessory/storage/webbing/pouches = 10,
		/obj/item/weapon/storage/backpack/duffel = 5,
		/obj/item/weapon/storage/briefcase = 5,
		/obj/item/clothing/accessory/holster/armpit = 10,
		/obj/item/clothing/accessory/holster/chest = 10,
		/obj/item/weapon/attachment/scope/adjustable/binoculars/binoculars = 10,
		/obj/item/clothing/glasses/sunglasses = 10,
		/obj/item/clothing/gloves/fingerless = 10,
		/obj/item/clothing/mask/balaclava = 10,
		/obj/item/clothing/head/ghillie = 1,
		/obj/item/clothing/suit/storage/ghillie = 1,
		/obj/item/flashlight/flashlight = 10,
		/obj/item/ammo_magazine/emptyspeedloader = 20,
		/obj/item/weapon/handcuffs/rope = 50,
	)
/obj/structure/vending/undercover_apparel
	name = "undercover apparel"
	desc = "All the equipment needed for undercover missions."
	icon_state = "apparel_german2"
	products = list(
		/obj/item/clothing/suit/storage/jacket/charcoal_suit = 10,
		/obj/item/clothing/suit/storage/jacket/black_suit = 10,
		/obj/item/clothing/suit/storage/jacket/navy_suit = 10,
		/obj/item/clothing/shoes/laceup = 10,
		/obj/item/clothing/glasses/sunglasses = 10,
		/obj/item/clothing/under/expensive/red = 10,
		/obj/item/clothing/accessory/armband/british = 10,
		/obj/item/clothing/under/expensive/yellow = 10,
		/obj/item/clothing/accessory/armband/spanish = 10,
		/obj/item/clothing/under/expensive/green = 10,
		/obj/item/clothing/accessory/armband/portuguese = 10,
		/obj/item/clothing/under/expensive/blue = 10,
		/obj/item/clothing/accessory/armband/french = 10,
		/obj/item/weapon/storage/backpack/duffel = 10,
		/obj/item/weapon/storage/briefcase = 10,
		/obj/item/clothing/accessory/holster/armpit = 10,
		/obj/item/clothing/accessory/holster/chest = 10,
	)
	attack_hand(mob/user as mob)
		if (user.original_job_title == "Police Officer")
			..()
		else
		 user << "You do not have access to this."
		 return

/obj/structure/vending/sales/business_weapons
	name = "weapon and ammo rack"
	desc = "When you need to pack that extra punch."
	icon_state = "weapons_sof"
	products = list(
		/obj/item/weapon/gun/projectile/pistol/colthammerless = 5,
		/obj/item/weapon/gun/projectile/pistol/colthammerless/m1908 = 5,
		/obj/item/weapon/gun/projectile/pistol/m1911 = 5,
		/obj/item/weapon/gun/projectile/revolver/smithwesson = 10,
//		/obj/item/weapon/gun/projectile/shotgun/pump = 2,
//		/obj/item/weapon/gun/projectile/boltaction/m24 = 2,
		/obj/item/weapon/attachment/silencer/pistol = 5,

		/obj/item/weapon/plastique/c4 = 2,
		/obj/item/ammo_magazine/colthammerless = 20,
		/obj/item/ammo_magazine/colthammerless/a380acp = 20,
		/obj/item/ammo_magazine/m1911 = 20,
		/obj/item/ammo_magazine/c32 = 10,
//		/obj/item/ammo_magazine/shellbox = 10,
//		/obj/item/ammo_magazine/shellbox/slug = 10,
//		/obj/item/ammo_magazine/m24 = 10,

		/obj/item/clothing/glasses/nvg = 2,
		/obj/item/clothing/accessory/armor/nomads/civiliankevlar = 4,
	)
	prices = list(
		/obj/item/weapon/gun/projectile/pistol/colthammerless = 300,
		/obj/item/weapon/gun/projectile/pistol/colthammerless/m1908 = 300,
		/obj/item/weapon/gun/projectile/pistol/m1911 = 400,
		/obj/item/weapon/gun/projectile/revolver/smithwesson = 240,
		/obj/item/weapon/gun/projectile/shotgun/remington870 = 500,
		/obj/item/weapon/gun/projectile/boltaction/m24 = 600,
		/obj/item/weapon/attachment/silencer/pistol = 120,

		/obj/item/weapon/plastique/c4 = 800,
		/obj/item/ammo_magazine/colthammerless = 40,
		/obj/item/ammo_magazine/colthammerless/a380acp = 40,
		/obj/item/ammo_magazine/m1911 = 40,
		/obj/item/ammo_magazine/c32 = 80,
		/obj/item/ammo_magazine/shellbox = 80,
		/obj/item/ammo_magazine/shellbox/slug = 80,
		/obj/item/ammo_magazine/m24 = 80,

		/obj/item/clothing/glasses/nvg = 100,
		/obj/item/clothing/accessory/armor/nomads/civiliankevlar = 400,
	)
	attack_hand(mob/living/human/user as mob)
		if (user.gun_permit)
			..()
		else
		 user << "You do not have a valid gun permit. Get one first from your local police station."
		 return
	attackby(obj/item/I, mob/living/human/user)
		if (user.gun_permit)
			..()
		else
		 user << "You do not have a valid gun permit. Get one first from your local police station."
		 return
/obj/structure/vending/police_equipment
	name = "police equipment"
	desc = "All the equipment to keep your officers in top shape."
	icon_state = "apparel_german2"
	products = list(
		/obj/item/stack/medical/bruise_pack/gauze = 15,
		/obj/item/clothing/accessory/holster/hip = 15,
		/obj/item/weapon/attachment/scope/adjustable/binoculars/binoculars = 15,
		/obj/item/clothing/glasses/sunglasses = 15,
		/obj/item/clothing/gloves/thick/swat = 15,
		/obj/item/clothing/head/helmet/swat = 15,
		/obj/item/clothing/mask/gas/swat = 15,
		/obj/item/clothing/suit/police = 15,
		/obj/item/clothing/head/helmet/constable = 15,
		/obj/item/clothing/under/constable = 15,
		/obj/item/clothing/shoes/swat = 15,
		/obj/item/weapon/storage/backpack/civbag = 15,
		/obj/item/weapon/melee/nightbaton = 15,
		/obj/item/weapon/storage/box/handcuffs = 10,
	)
	attack_hand(mob/user as mob)
		if (user.original_job_title == "Police Officer")
			..()
		else
		 user << "You do not have access to this."
		 return

/obj/structure/vending/police_weapons
	name = "police weapons"
	desc = "When the baton is not enough."
	icon_state = "weapons_sof"
	products = list(
	/obj/item/weapon/gun/projectile/shotgun/remington870 = 10,
	/obj/item/ammo_magazine/shellbox/rubber = 10,
	/obj/item/ammo_magazine/shellbox = 10,
	/obj/item/weapon/gun/projectile/pistol/glock17 = 20,
	/obj/item/ammo_magazine/glock17 = 50,
	/obj/item/weapon/gun/launcher/grenadelauncher/M79 = 5,
	/obj/item/ammo_casing/grenade_l/teargas = 20,
	/obj/item/weapon/grenade/flashbang = 20,

	)
	attack_hand(mob/user as mob)
		if (user.original_job_title == "Police Officer")
			..()
		else
		 user << "You do not have access to this."
		 return

/obj/item/weapon/package
	name = "package"
	desc = "Some kind of package."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "deliverypackage"
	item_state = "deliverypackage"
	flammable = FALSE
	density = FALSE
	opacity = FALSE
	force = 9.0
	throwforce = 10.0

	attack_verb = list("bashed", "bludgeoned", "whacked")
	sharp = FALSE
	edge = FALSE
	w_class = 3.0
/obj/item/weapon/paper_bin/police
	name = "incomming documents"
	desc = "incomming documents and warrants will arrive here."
	amount = 0
/obj/item/weapon/paper/police
	icon_state = "police_record"
	base_icon = "police_record"
	name = "Police Record"
	var/spawntimer = 0
/obj/item/weapon/paper/police/warrant
	icon_state = "police_record"
	base_icon = "police_record"
	name = "Arrest Warrant"
	var/reason = "Mischief"
	var/mob/living/human/tgt_mob = null
	var/tgt = "Unknown"
	var/tgtcmp = "Unknown"
	var/arn = 0
	New()
		..()
		arn = rand(1000,9999)
		icon_state = "police_record"
		spawn(10)
			info = "<center>POLICE DEPARTMENT<hr><large><b>Arrest Warrant No. [arn]</b></large><hr><br>Police forces are hereby authorized and directed to detain <b>[tgt]</b>, working for <b><i>[tgtcmp]</i></b>, for the following reasons:<br><br><i>- [reason]</i><br><br>They will disregard any claims of immunity or privilege by the Suspect or agents acting on the Suspect's behalf. Police forces shall bring <b>[tgt]</b> forthwith to the Police Station.<br><br><small><center><i>Form Model 13-B</i><center></small><hr>"
		spawn(100)
			if (spawntimer)
				spawn(spawntimer)
					qdel(src)
/obj/item/weapon/paper/police/searchwarrant
	icon_state = "police_warrant"
	base_icon = "police_warrant"
	name = "Search Warrant"
	var/cmp = "Unknown"
	var/arn = 0
	New()
		..()
		arn = rand(100,999)
		icon_state = "police_warrant"
		spawn(10)
			info = "<center>POLICE DEPARTMENT<hr><large><b>Search Warrant No. [arn]</b></large><hr><br>Police forces are hereby authorized and directed to search all and every property owned by <b>[cmp]</b>. They will disregard any claims of immunity or privilege by the Suspect or agents acting on the Suspect's behalf.<br><br><small><center><i>Form Model 13-C1</i></center></small><hr>"
//////////////////SCREEN HELPERS////////////////////////////
/obj/screen/areashow_aod
	maptext = "<center><font color='yellow'>Unknown Area</font></center>"
	maptext_width = 32*8
	maptext_x = (32*8 * -0.5)+32
	maptext_y = 32*0.75
	icon_state = "blank"

/obj/screen/areashow_aod/New()
	..()
	spawn(50)
		update()

/obj/screen/areashow_aod/proc/update()
	if (!parentmob || !src)
		return
	var/cloc = "Unknown"
	cloc = parentmob.get_coded_loc()
	maptext = "<center><font color='yellow'><b>[cloc]</b>  ([parentmob.x],[parentmob.y])</font></center>"

	spawn(10)
		update()
/mob/proc/get_coded_loc()
	var/a = ceil(x/22)
	var/b = 10-ceil(y/22)
	switch(a)
		if (0 to 1)
			a = "A"
		if (1 to 2)
			a = "B"
		if (2 to 3)
			a = "C"
		if (3 to 4)
			a = "D"
		if (4 to 5)
			a = "E"
		if (5 to 6)
			a = "F"
		if (6 to 7)
			a = "G"
		if (7 to 8)
			a = "H"
		if (8 to 9)
			a = "I"
		if (9 to 10)
			a = "J"
	return "[a][b]"
/mob/living/human/var/hidden_name = ""

/mob/living/human/proc/undercover()
	set category = "IC"
	set name = "Toggle Undercover"
	set desc="Hide your identity for police operations."

	if (findtext(name, "Officer"))
		real_name = replacetext(real_name, "Officer ", "")
		hidden_name = real_name
		var/chosen_name = WWinput(src, "Which ethnicity do you want your name to be?","Choose Name","Cancel",list("Cancel","Russian","Jewish","Italian","Irish"))
		switch(chosen_name)
			if ("Cancel")
				return
			if ("Russian")
				chosen_name =  species.get_random_russian_name(gender)
			if ("Irish")
				chosen_name =  species.get_random_gaelic_name(gender)
			if ("Italian")
				chosen_name =  species.get_random_italian_name(gender)
			if ("Jewish")
				chosen_name =  species.get_random_hebrew_name(gender)
		name = chosen_name
		real_name = chosen_name
		voice = chosen_name
		src << "<b><big>You go undercover.</big></b>"
		return
	else
		real_name = "Officer [hidden_name]"
		name = "Officer [hidden_name]"
		voice = "Officer [hidden_name]"
		src << "<b><big>You are now revealing your identity again.</big></b>"
		return

/obj/item/clothing/accessory/armband/policebadge
	name = "police badge"
	desc = "a police badge in star shape, with an officer's name engraved."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "sheriff"
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = TRUE
	throw_range = 2
	w_class = 1.0
	flammable = FALSE
	slot_flags = SLOT_POCKET|SLOT_BELT

/obj/item/clothing/accessory/armband/policebadge/secondary_attack_self(mob/living/human/user)
	showoff(user)

/mob/living/human/var/gun_permit = FALSE