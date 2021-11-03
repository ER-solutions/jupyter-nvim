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
	path = vim.fn.expand('%:p:h')
	print("Starting webclient at "..port)
	-- local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook '..path..'/test.sync.ipynb'
	local cmd = 'x-www-browser http://localhost:'..port
	start_jupyter_web_client_proc = my_proc("start_jupyter_web_client", cmd)
	-- read_proc(start_jupyter_proc)
end

local function start_jupyter_notebook(ipynb_sync_file)
	path = vim.fn.expand('%:p:h')
	print("path = "..path)
	-- local cmd = 'jupyter notebook '..ipynb_sync_file
	local cmd = 'jupyter notebook --no-browser'
	start_jupyter_proc = my_proc("start_jupyter", cmd)
	-- start_jupyter_web_client()
	-- read_proc(start_jupyter_proc)
end

local function server_list_enter_pressed()
	local cmd
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]-1
	if row >= 1 and row <= table_length(lines_table) then
		local port = lines_table[cursor[1]-1].port
		start_jupyter_web_client(port)
	else
		vim.cmd(':q')
	end
end

local function fetch_notebook_servers()
	create_floating_window()
	pl("Fetching jupyter notebook servers")
	fetch_handle = assert(io.popen("jupyter notebook list --jsonlist"))
	lines = fetch_handle:read("*all")
	lines_table = json.decode(lines)
	vim.cmd("normal! ggdG")
	pl("Jupyter notebook servers:")
	if table_length(lines_table) > 0 then
		for k,v in pairs(lines_table) do
			pl(k..": "..lines_table[k].hostname..":"..lines_table[k].port..lines_table[k].notebook_dir)
			lastv = v
		end
		-- print_table_keys(lastv)
	end

	vim.cmd("nnoremap <buffer> <enter> :lua require('jupyter-nvim').server_list_enter_pressed()<CR>")
	vim.cmd("nnoremap <buffer> <backspace> :lua require('jupyter-nvim').stop_jupyter_notebook()<CR>:q<CR>:lua require('jupyter-nvim').fetch_notebook_servers()<CR>")
	vim.cmd("setlocal noma")
end

local function stop_jupyter_notebook()
	local cmd
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]-1
	if row >= 1 and row <= table_length(lines_table) then
		cmd = 'jupyter notebook stop '..lines_table[cursor[1]-1].port
		path = vim.fn.expand('%:p:h')
		stop_jupyter_proc = my_proc("stop_jupyter", cmd)
		read_proc(stop_jupyter_proc)
		close_proc(stop_jupyter_proc)
	end
end

local function create_jupytext_pair(ipynb_name)
	ipynb_base = filebase(ipynb_name)
	ipynb_sync_file = ipynb_base..'.sync.ipynb'
	local pair = my_proc('pair', '/bin/cp '..ipynb_name..' '..ipynb_sync_file)
	read_proc(pair)
	close_proc(pair)
	local pair = my_proc('pair','jupytext --to py:percent '..ipynb_sync_file)
	read_proc(pair)
	close_proc(pair)
	-- os.execute("/home/eetakala/miniconda3/bin/jupyter notebook")
	return ipynb_sync_file
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

local function set_up_jupyter_ascending_for_ipynb_file()
	ipynb_name = vim.fn.expand('%')
	ipynb_sync_file = create_jupytext_pair(ipynb_name)
	py_sync_file = filebase(ipynb_name)..".sync.py"
	start_jupyter_notebook(ipynb_sync_file)
	vim.cmd('e '..py_sync_file)
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
