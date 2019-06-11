-- to avoid collisions with other mods, all assets specific to this mod are prefixed with "testmod.*"

import "testmod/particles/glitter.lua"

def_site{
	name = "testmod.test_site",
	ui_name = "O'Mighty Site of Testing",
}

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
}

def_material{
	name = "testmod.floor_material",
	diffuse_texture = "data/textures/dungeon_tile_floor_dif.png",
	specular_texture = "data/textures/dungeon_tile_floor_spec.png",
	normal_texture = "data/textures/dungeon_tile_floor_normal.png",
}

def_object{
	name = "testmod.test_box",
	model = "data/models/whitebox_1x1x1.fbx",
	model_material = "testmod.floor_material",
	particle_system = "testmod.glitter",
	flags = F_BLOCK_MOVE + F_BLOCK_SIGHT,
	tags = { "testmod" },
}

--                                      HEALTH     ARMOR   DAMAGE                    capsule   smpl
--       name                           e  m  h    e m h   e m h   spd anim size xp  loot hgt  rad  rad  flags             immunities      misc
def_mob{ "testmod.super_centipede",     5, 6, 8,   0,1,1,  2,5,5,  5,  4.62, 1,  5,  1,   1.0, 0.5, 0.8, MF_AMPHIBIOUS,    0,              skin = "centipede" }

def_aux{
	name = "testmod.super_centipede",
	ui_name = "Super Centipede",
	model_material = "testmod.floor_material",
}

-- make alterations to the world map
register_global_hook("on_enter_world_map", function(map)
	local site = spawn("map_herb_plant", map, 0, 0, 0)
	register_named_obj(map, site, "testmod.test_site")
	set_world_pos3(site, 103.9435, 1.2914, -129.9235)
	set_world_rot_euler(site, 0.0, math.rad(39,4243), 0.0)
	set_obj_scale3(site, 0.45, 0.45, 0.45)
end)
