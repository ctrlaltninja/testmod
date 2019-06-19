lever_pulled = false

function on_init_map()
	-- add a temporary ability for the first hero
	set_inventory(party[1].inventory, "$mod.flip_coin", 1)

	-- level scripts can call functions defined in mod_main.lua
	test_function()
end

function on_toggle_lever(mob, lever)
	lever_pulled = true
end

function on_draw_objectives(map, ctx)
	local status
	if lever_pulled then status = true end
	ctx.objective("pull_lever", "Pull the Lever", status, "P")
	ctx.bonus_objective_loot_box()
end
