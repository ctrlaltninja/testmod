lever_pulled = false

function on_init_map()
	print_msg("init map")
end

function on_toggle_lever(mob, lever)
	lever_pulled = true
end

function on_draw_objectives(map, ctx)
	local status
	if lever_pulled then status = true end
	ctx.objective("pull_lever", "Pull the Lever", status, "P")
end
