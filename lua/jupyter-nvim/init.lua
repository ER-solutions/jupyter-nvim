
local function pl(msg)
	vim.api.nvim_paste(msg.."\n", true, -1)
end

local function printLoadedPackages()
	pl("Test: printLoadedPackages()")
	pl("This function prints package.loaded table keys:")
	for k in pairs(package.loaded) do
		pl(k)
	end
end

local function printWindowSize()
	print (vim.api.nvim_win_get_width(0),vim.api.nvim_win_get_height(0))
end

local function setWindowSize(x,y)
	vim.api.nvim_win_set_width(0,x)
	vim.api.nvim_win_set_height(0,y)
end

local function createFloatingWindow()
	local uis = vim.api.nvim_list_uis()
	local ui = uis[1]
	local width = ui.width
	local height = ui.height

	local bufh = vim.api.nvim_create_buf(false, true)
	local wId = vim.api.nvim_open_win(bufh, true, {
		relative = "editor",
		width = 80,
		height = height,
		col = 2,
		row = 2
	})

	local window_stuff = {}
	window_stuff.bufh = bufh
	window_stuff.wId = wId
	vim.api.nvim_command('set nonu')
	pl('testing the nvim_put() function:')
	pl('window size:'..width..'x'..height)
	printLoadedPackages()
	return window_stuff
end

local function onResize()
	local uis = vim.api.nvim_list_uis()
	local ui = uis[1]
	local width = ui.width
	local height = ui.height
	pl("Window size", width, height)
end

local function printTable(table)
	for k in pairs(table) do
		print (k)
	end
end

local function printTestVar()
	--printTable(vim)
	global_test_var = vim.api.nvim_get_var('global_test_var')
	print(global_test_var)
end

local function test()
	createFloatingWindow()
end

return {
	test = test,
	createFloatingWindow = createFloatingWindow,
	onResize = onResize
}
