-- to avoid collisions with other mods, all assets specific to this mod are prefixed with "testmod.*"

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

def_particles{
	name = "testmod.glitter",
	emitters = {
		{
			shape = "box",
			emission_rate = 500,
			emission_time = 0,
			max_particles = 1000,
			spawn_burst = false,
			object_space = false,
			position = {0, 2.0, 0},
			size = {4.0, 4.0, 4.0},
			spray_angle = {0, 360},
			velocity = {1, 3},
			gravity = {0, 0, 0},
			air_resistance = 5,
			lifetime = {0.1, 0.15},
			texture = load_texture("data/textures/particles/teleporter.png", "dxt5_srgb"),
			blend_mode = "additive_src_alpha",
			intensity = 1,
			opacity = 1,
			color = {3, 3, 3},
			fade_in = 0.1,
			fade_out = 0.1,
			particle_size = {0.05, 0.5},
			rotation_speed = 2,
			random_rotation = true,
			depth_bias = 0,
		},
	}
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
