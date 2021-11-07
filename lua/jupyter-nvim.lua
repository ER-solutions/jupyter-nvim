my_proc = require("proc").my_proc
read_proc = require("proc").read_proc
close_proc = require("proc").close_proc
create_floating_window = require("window").create_floating_window
pl = require("window").pl
json = require("json")
print_table_keys = require("helpers").print_table_keys
table_length = require("helpers").table_length
filebase = require("helpers").filebase

local function set_test_mappings()
	vim.api.nvim_set_keymap('n', '<enter>', ':lua require("jupyter-nvim").set_up_jupyter_ascending_for_ipynb_file()<esc>', { noremap = true, silent = true })

end

local function start_jupyter_web_client(port)
	local path = vim.fn.expand('%:p:h')
	print("Starting webclient at "..port)
	-- local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook '..path..'/test.sync.ipynb'
	local cmd = 'x-www-browser http://localhost:'..port
	local start_jupyter_web_client_proc = my_proc("start_jupyter_web_client", cmd)
end

local function start_jupyter_notebook(ipynb_sync_file)
	local path = vim.fn.expand('%:p:h')
	print("path = "..path)
	-- local cmd = 'jupyter notebook '..ipynb_sync_file
	local cmd = 'jupyter notebook --no-browser'
	start_jupyter_proc = my_proc("start_jupyter", cmd)
end

local function create_jupytext_pair(ipynb_name)
	local ipynb_base = filebase(ipynb_name)
	local ipynb_sync_file = ipynb_base..'.sync.ipynb'
	local pair = my_proc('pair', '/bin/cp '..ipynb_name..' '..ipynb_sync_file)
	read_proc(pair)
	close_proc(pair)
	local pair = my_proc('pair','jupytext --to py:percent '..ipynb_sync_file)
	read_proc(pair)
	close_proc(pair)
	-- os.execute("/home/eetakala/miniconda3/bin/jupyter notebook")
	return ipynb_sync_file
end

local function set_up_jupyter_ascending_for_ipynb_file()
	local ipynb_name = vim.fn.expand('%')
	local ipynb_sync_file = create_jupytext_pair(ipynb_name)
	local py_sync_file = filebase(ipynb_name)..".sync.py"
	-- start_jupyter_notebook(ipynb_sync_file)
	vim.cmd('e '..py_sync_file)
end

local function start_jupyter_notebook_for_sync_file()
	local ipynb_sync_file = vim.fn.expand('%')
	start_jupyter_notebook(ipynb_sync_file)
end

local function operate_on_server_list(operation)
	local cmd
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]

	if operation == "start" then
		local rows = 1 -- number of help text rows -- This sucks! TODO: create or find a real selector ui component.
		if row > 0 + rows and row <= rows + table_length(servers_table) then
			local port = servers_table[cursor[1]-rows].port
			start_jupyter_web_client(port)
		else
			vim.cmd(':q')
			if row == rows + 1 then
				start_jupyter_notebook_for_sync_file()
			end
		end
	elseif operation == "stop" then
		local rows = 1 -- number of help text rows -- This sucks!
		if row > 0 + rows and row <= rows + table_length(servers_table) then
			cmd = 'jupyter notebook stop '..servers_table[cursor[1]-rows].port
			local stop_jupyter_proc = my_proc("stop_jupyter", cmd)
			read_proc(stop_jupyter_proc)
			close_proc(stop_jupyter_proc)
		end
	end
end

local function server_list_enter_pressed()
	operate_on_server_list("start")
end

local function stop_jupyter_notebook()
	operate_on_server_list("stop")
end

local function fetch_notebook_servers()
	create_floating_window()
	pl("Fetching jupyter notebook servers")
	local fetch_handle = assert(io.popen("jupyter notebook list --jsonlist"))
	local lines = fetch_handle:read("*all")
	servers_table = json.decode(lines)
	vim.cmd("normal! ggdG")
	if table_length(servers_table) > 0 then
		pl("Jupyter notebook servers:")
		for k,v in pairs(servers_table) do
			pl(k..": "..servers_table[k].hostname..":"..servers_table[k].port..servers_table[k].notebook_dir)
			-- lastv = v
		end
		pl("")
		pl("Move your cursor to a server row")
		pl("\t- Press enter to launch a browser for the server")
		pl("\t- Press back space to stop the server")
		-- print_table_keys(lastv)
		vim.cmd("normal 5k")
	else
		pl("No servers found. Move your cursor to one of the options and press enter:")
		pl("\t 1. Launch a server!")
		pl("\t 2. Quit!")
		vim.cmd("normal k")
	end

	vim.cmd("nnoremap <buffer> <enter> :lua require('jupyter-nvim').server_list_enter_pressed()<CR>")
	vim.cmd("nnoremap <buffer> <backspace> :lua require('jupyter-nvim').stop_jupyter_notebook()<CR>:q<CR>:lua require('jupyter-nvim').fetch_notebook_servers()<CR>")
	vim.cmd("setlocal noma")
end

local function sync_original(ipynb_sync_name)
	local ipynb_base = filebase(ipynb_sync_name)
	local ipynb_base = filebase(ipynb_base)
	local ipynb_sync_name = ipynb_base..".sync.ipynb"
	local ipynb_original = ipynb_base..".ipynb"
	local cmd = '/bin/cp '..ipynb_sync_name..' '..ipynb_original
	local sync = my_proc('sync', cmd)
	read_proc(sync)
	close_proc(sync)
end

return {
	start_jupyter_notebook = start_jupyter_notebook,
	read_jupyter_notebook = read_jupyter_notebook,
	stop_jupyter_notebook = stop_jupyter_notebook,
	create_jupytext_pair = create_jupytext_pair,
	set_test_mappings = set_test_mappings,
	fetch_notebook_servers = fetch_notebook_servers,
	set_up_jupyter_ascending_for_ipynb_file = set_up_jupyter_ascending_for_ipynb_file,
	set_test_mappings = set_test_mappings,
	sync_original = sync_original,
	server_list_enter_pressed = server_list_enter_pressed
}
