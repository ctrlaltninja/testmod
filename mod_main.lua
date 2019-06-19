-- To avoid collisions with built-in game assets and assets defined in other mods
-- all mod specific asset names should be put into namespace. To avoid repeating
-- the (possibly quite long) namespace everywhere, it's set up here once. All 
-- occurrences of '$mod' in strings in Lua code are automatically replaced with
-- the namespace. For example, the asset name "$mod.test_box" is converted to
-- "ctrl_alt_ninja_testmod.test_box" when the mod is loaded into memory.
namespace "ctrl_alt_ninja_testmod"

import "mod_data/particles/glitter.lua"

-- define a new site on the world map
def_site{
	name = "$mod.test_site",
	ui_name = "O'Mighty Site of Testing",
}

-- define a new mission
def_mission{
	name = "$mod.test",
	site = "$mod.test_site",
	ui_name = "Test Mission",
	level_filename = "mod_data/levels/test.level",
	letter_text =
		"From: The devs\n" ..
		"To: To all modders\n" ..
		"Subject: Welcome!\n\n" ..
		"Welcome to modding Druidstone! We hope to see lots of cool mods in the coming months.",
	locked = false,
	loot = { "$mod.shovel", "$mod.t_shirt", "$mod.necklace" },	-- contents of the loot box
}

-- define a new rendering material
def_material{
	name = "$mod.test_material",
	diffuse_texture = "mod_data/textures/centipede_yellow_dif.png",
	specular_texture = "data/textures/dungeon_tile_floor_spec.png",
	normal_texture = "data/textures/dungeon_tile_floor_normal.png",
}

-- define a new type of object that can be placed in the editor
def_object{
	name = "$mod.test_box",
	model = "data/models/whitebox_1x1x1.fbx",
	model_material = "$mod.test_material",
	particle_system = "$mod.glitter",
	flags = F_BLOCK_MOVE + F_BLOCK_SIGHT,
	tags = { "$mod" },
}

-- define a new type of object with custom model
def_object{
	name = "$mod.test_sphere",
	model = "mod_data/models/sphere.fbx",
	tags = { "$mod" },
}

-- ai function for super centipede's freezing attack
function ai_centipede_freeze_attack(mob, item_name)
	local targets = ai_find_enemies(mob, function(t) return not get_condition(t, C_FREEZE) and obj_distance(mob, t) == 1 end)
	if targets and #targets > 0 then
		return ai_melee(mob, item_name, targets)
	end
end

-- use function for super centipede's freezing attack
function use_centipede_freeze_attack(mob, item_name, target_x, target_y)
	local map = mob.map
	spend_item(mob, item_name)

	turn_mob_towards(mob, target_x, target_y)

	local target = get_mob(map, target_x, target_y)
	shoot_projectile(map, "bolt", mob, target)

	local attack_params = get_attack_params(mob, item_name)
	execute_attack(map, mob, target_x, target_y, attack_params)
	return true
end

-- create a new type of super centipede
clone_object{
	name = "$mod.super_centipede",
	base_object = "centipede",
	ui_name = "Super Centipede",
	model_material = "$mod.test_material",
	mob_speed = 5,
	mob_damage_easy = 3,
	mob_damage = 4,
	mob_damage_hard = 5,	
	ai_routine = {
		ai_advance,
		{ ai_centipede_freeze_attack, "freeze_attack", 1 },
		ai_melee,
	},
	freeze_attack = {
		flags = IF_ACTION + IF_CONSUMABLE + IF_OFFENSIVE,
		damage = "b",	-- use mob's base damage
		inflict = C_FREEZE,
		on_use_item = use_centipede_freeze_attack,
		initial_cooldown = {0, 1},
		cooldown = {1, 3},
		attack_sound = "centipede_poison_attack",
	},
	inventory = { "freeze_attack", 3 },	-- three uses of freeze attack
	mob_description = "A new deadlier type of centipede.",
}

-- define a new ability with a custom icon
def_ability{
	name = "$mod.flip_coin",
	ui_name = "Flip Coin",
	ability_type = "b",
	item_icon = 0,
	icon_texture = load_texture("mod_data/textures/items.png", "rgba8"),
	damage = 2,
	range = 1,
	flags = IF_ACTION,
	description = "An example of a new ability which flips a coin.",
	on_use_item = function(mob, item_name, target_x, target_y)
		if confirm_use_item(mob, item_name, "Flip It!") then
			spend_item(mob, item_name)

			if shb_random_int(1, 2) == 1 or is_power_activated2(mob, "$mod.flip_coin_lucky") then
				add_damage_text("Heads!", mob)
			else
				add_damage_text("Tails!", mob)
			end
		end
	end,
	powers = { { id = "lucky", name = "Lucky", cost = 1, tooltip = "Always get heads when this power is activated." } },
}

-- define a new type of weapon
def_weapon{
	name = "$mod.shovel",
	ui_name = "Shovel",
	item_icon = 1,
	icon_texture = load_texture("mod_data/textures/items.png", "rgba8"),
	weapon_type = "melee",
	damage = 1,
	anim_set = 1,
	price = 50,
	attack_sound = "swing",
	flags = IF_LIGHT_WEAPON,
	powers = { power_damage_bonus(1, 1) },
}

-- the object attached to wielder's hand when the weapon '$mod.shovel' is equipped
def_object{
	name = "$mod.shovel_attachment",
	model = "data/models/dagger.fbx",
	model_can_emit_particles = true,
	editor_ignore_asset = true,
}

-- define a new type of armor
def_armor{
	name = "$mod.t_shirt",
	ui_name = "T-Shirt",
	item_icon = 95,
	armor_health_bonus = 1,
	price = 50,
	flags = IF_LIGHT_ARMOR,
	powers = { power_health_bonus(2, 2) },
}

-- define a new type of accessory
def_accessory{
	name = "$mod.necklace",
	ui_name = "Necklace",
	item_icon = 9,
	price = 50,
	card_style = "text_box",
	description = "A beautiful jeweled necklace.",
}

-- define a new type of consumable
def_consumable{
	name = "$mod.chewing_gum",
	ui_name = "Magic Chewing Gum of Summoning",
	item_icon = 5,
	range = 5,
	description = "Summon a Slug.",
	on_use_item = function(mob, item_name, target_x, target_y)
		local map = mob.map

		if target_x == nil then
			target_x, target_y = choose_target(mob, item_name, TARGET_LOS_FROM_MOB + TARGET_UNBLOCKED_FOR_SUMMON)
			if target_x == nil then return end
		end

		spend_item(mob, item_name)
		spawn("slug", map, target_x, target_y, -1)
		remove_map_markers(map)

		return true
	end,
}

-- make alterations to the world map
register_global_hook("on_enter_world_map", function(map)
	local site = spawn("map_herb_plant", map, 0, 0, 0)
	register_named_obj(map, site, "$mod.test_site")
	set_world_pos3(site, 103.9435, 1.2914, -129.9235)
	set_world_rot_euler(site, 0.0, math.rad(39,4243), 0.0)
	set_obj_scale3(site, 0.45, 0.45, 0.45)
end)
