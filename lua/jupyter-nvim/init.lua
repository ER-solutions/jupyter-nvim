path='/home/eetakala/test/jupyter'

local function set_test_mappings()
	vim.api.nvim_set_keymap('n', '<enter>', ':lua require("jupyter-nvim").start_jupyter_notebook()<esc>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<backspace>', ':lua require("jupyter-nvim").stop_jupyter_notebook()<esc>', { noremap = true, silent = true })
end

local function my_proc(name, cmd)
	local proc = {}
	logfile = name..".log"
	proc.__handle = assert(io.popen(cmd.." 2> "..path..'/'..logfile,'r'))
	proc.__file = assert(io.open(path..'/'..logfile, 'r'))

	proc.lines = function(self)
		return self.__handle:lines()
	end
	
	proc.close = function(self)
		self.__handle:close()
		self.__file:close()
	end
	return proc
end

local function read_proc(proc)
	for line in proc:lines() do
		print(line)
	end
end

local function start_jupyter_notebook()
	path = vim.fn.expand('%:p:h')
	print("path = "..path)
	local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook '..path..'/test.sync.ipynb'
	start_jupyter_proc = my_proc("start_jupyter", cmd)
	-- read_proc(start_jupyter_proc)
end

local function stop_jupyter_notebook()
	local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook stop'
	stop_jupyter_proc = my_proc("stop_jupyter", cmd)
	read_proc(start_jupyter_proc)
	read_proc(stop_jupyter_proc)
	stop_jupyter_proc:close()
	start_jupyter_proc:close()
end

local function create_jupytext_pair(ipynb_name)
	pair = assert(io.popen('/bin/cp '..path..'/test.ipynb '..path..'/test.sync.ipynb'))
	read_process(pair)
	pair = assert(io.popen('/home/eetakala/miniconda3/bin/jupytext --to py:percent '..path..'/test.sync.ipynb'))
	read_process(pair)
	-- os.execute("/home/eetakala/miniconda3/bin/jupyter notebook")
end

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
	onResize = onResize,
	start_jupyter_notebook = start_jupyter_notebook,
	read_jupyter_notebook = read_jupyter_notebook,
	stop_jupyter_notebook = stop_jupyter_notebook,
	create_jupytext_pair = create_jupytext_pair,
	set_test_mappings = set_test_mappings
}
