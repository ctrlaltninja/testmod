-- this file has been automatically generated

def_particles{
	name = "$mod.glitter",
	emitters = {
		{
			shape = "box",
			emission_rate = 500,
			emission_time = 0,
			max_particles = 1000,
			hidden = false,
			spawn_burst = false,
			object_space = false,
			position = {0, 2, 0},
			size = {4, 4, 4},
			spray_angle = {0, 360},
			velocity = {1, 3},
			gravity = {0, 0, 0},
			air_resistance = 5,
			aspect_ratio = 1,
			lifetime = {0.1, 0.15},
			texture = load_texture("data/textures/particles/teleporter.png", "dxt5_srgb"),
			blend_mode = "additive_src_alpha",
			intensity = 1,
			opacity = 1,
			color = {3, 3, 3},
			fade_in = 0.1,
			fade_out = 0.1,
			particle_size = {0.05, 0.5},
			rotation_angle = 0,
			rotation_speed = 2,
			random_rotation = true,
			particle_scale_over_lifetime = 1,
			motion_blur = 0,
			depth_bias = 0,
		},
	}
}
