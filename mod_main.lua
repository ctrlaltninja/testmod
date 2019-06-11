-- to avoid collisions with built-in game assets or other mods, all assets specific to this mod are prefixed with "testmod.*"

import "testmod/particles/glitter.lua"

-- define a new site on the world map
def_site{
	name = "testmod.test_site",
	ui_name = "O'Mighty Site of Testing",
}

-- define a new mission
def_mission{
	name = "testmod.test",
	site = "testmod.test_site",
	ui_name = "Test Mission",
	level_filename = "testmod/test.level",
	letter_text =
		"From: The devs\n" ..
		"To: To all modders\n" ..
		"Subject: Welcome!\n\n" ..
		"Welcome to modding Druidstone! We hope to see lots of cool mods in the coming months.",
	locked = false,
	loot = { "testmod.shovel", "testmod.t_shirt", "testmod.necklace" },	-- contents of the loot box
}

-- define a new rendering material
def_material{
	name = "testmod.test_material",
	diffuse_texture = "testmod/textures/centipede_yellow_dif.png",
	specular_texture = "data/textures/dungeon_tile_floor_spec.png",
	normal_texture = "data/textures/dungeon_tile_floor_normal.png",
}

-- define a new type of object that can be placed in the editor
def_object{
	name = "testmod.test_box",
	model = "data/models/whitebox_1x1x1.fbx",
	model_material = "testmod.test_material",
	particle_system = "testmod.glitter",
	flags = F_BLOCK_MOVE + F_BLOCK_SIGHT,
	tags = { "testmod" },
}

-- define a new type of object with custom model
def_object{
	name = "testmod.test_sphere",
	model = "testmod/models/sphere.fbx",
	tags = { "testmod" },
}

--                                      HEALTH     ARMOR   DAMAGE                    capsule   smpl
--       name                           e  m  h    e m h   e m h   spd anim size xp  loot hgt  rad  rad  flags             immunities      misc
def_mob{ "testmod.super_centipede",     5, 6, 8,   0,1,1,  2,5,5,  5,  4.62, 1,  5,  1,   1.0, 0.5, 0.8, MF_AMPHIBIOUS,    0,              skin = "centipede" }

def_aux{
	name = "testmod.super_centipede",
	ui_name = "Super Centipede",
	model_material = "testmod.test_material",
}

-- define a new ability with a custom icon
def_ability{
	name = "testmod.flip_coin",
	ui_name = "Flip Coin",
	ability_type = "b",
	item_icon = 0,
	icon_texture = load_texture("testmod/textures/items.png", "rgba8"),
	damage = 2,
	range = 1,
	flags = IF_ACTION,
	description = "An example of a new ability which flips a coin.",
	on_use_item = function(mob, item_name, target_x, target_y)
		if confirm_use_item(mob, item_name, "Flip It!") then
			spend_item(mob, item_name)

			if shb_random_int(1, 2) == 1 or is_power_activated2(mob, "testmod.flip_coin_lucky") then
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
	name = "testmod.shovel",
	ui_name = "Shovel",
	item_icon = 1,
	icon_texture = load_texture("testmod/textures/items.png", "rgba8"),
	weapon_type = "melee",
	damage = 1,
	anim_set = 1,
	price = 50,
	attack_sound = "swing",
	flags = IF_LIGHT_WEAPON,
	powers = { power_damage_bonus(1, 1) },
}

-- the object attached to wielder's hand when the weapon 'testmod.shovel' is equipped
def_object{
	name = "testmod.shovel_attachment",
	model = "data/models/dagger.fbx",
	model_can_emit_particles = true,
	editor_ignore_asset = true,
}

-- define a new type of armor
def_armor{
	name = "testmod.t_shirt",
	ui_name = "T-Shirt",
	item_icon = 95,
	armor_health_bonus = 1,
	price = 50,
	flags = IF_LIGHT_ARMOR,
	powers = { power_health_bonus(2, 2) },
}

-- define a new type of accessory
def_accessory{
	name = "testmod.necklace",
	ui_name = "Necklace",
	item_icon = 9,
	price = 50,
	card_style = "text_box",
	description = "A beautiful jeweled necklace.",
}

-- define a new type of consumable
def_consumable{
	name = "testmod.chewing_gum",
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
	register_named_obj(map, site, "testmod.test_site")
	set_world_pos3(site, 103.9435, 1.2914, -129.9235)
	set_world_rot_euler(site, 0.0, math.rad(39,4243), 0.0)
	set_obj_scale3(site, 0.45, 0.45, 0.45)
end)
