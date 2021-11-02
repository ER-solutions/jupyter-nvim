my_proc = require("proc").my_proc
read_proc = require("proc").read_proc
close_proc = require("proc").close_proc
create_floating_window = require("window").create_floating_window
pl = require("window").pl
json = require("json")
print_table_keys = require("helpers").print_table_keys
table_length = require("helpers").table_length

local function set_mappings()
	vim.api.nvim_set_keymap('n', '<enter>', ':lua require("jupyter-nvim").start_jupyter_notebook()<esc>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<enter>', ':lua require("jupyter-nvim").set_up_jupyter_ascending_for_ipynb_file()<esc>', { noremap = true, silent = true })

	vim.api.nvim_set_keymap('n', '<backspace>', ':lua require("jupyter-nvim").stop_jupyter_notebook()<esc>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader><enter>', ':lua require("jupyter-nvim").fetch_notebook_servers()<esc>', { noremap = true, silent = true })
end

local function start_jupyter_web_client()
	path = vim.fn.expand('%:p:h')
	print("Starting webclient "..path)
	-- local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook '..path..'/test.sync.ipynb'
	local cmd = 'x-www-browser http://localhost:8888/notebooks/test.sync.ipynb'
	start_jupyter_web_client_proc = my_proc("start_jupyter_web_client", cmd)
	-- read_proc(start_jupyter_proc)
end

local function start_jupyter_notebook(ipynb_sync_file)
	path = vim.fn.expand('%:p:h')
	print("path = "..path)
	local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook '..ipynb_sync_file
	-- local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook --no-browser'
	start_jupyter_proc = my_proc("start_jupyter", cmd)
	-- start_jupyter_web_client()
	-- read_proc(start_jupyter_proc)
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

	vim.cmd("nnoremap <buffer> <enter> :q<CR>")
	vim.cmd("setlocal noma")

end

local function stop_jupyter_notebook()
	path = vim.fn.expand('%:p:h')
	local cmd = '/home/eetakala/miniconda3/bin/jupyter notebook stop'
	stop_jupyter_proc = my_proc("stop_jupyter", cmd)
	read_proc(start_jupyter_proc)
	read_proc(stop_jupyter_proc)
	close_proc(stop_jupyter_proc)
	close_proc(start_jupyter_proc)
end

local function filebase(filepath)
	local filebase = filepath:match("(.+)%..+")
	return filebase
end

local function create_jupytext_pair(ipynb_name)
	ipynb_base = filebase(ipynb_name)
	ipynb_sync_file = ipynb_base..'.sync.ipynb'
	pair = assert(io.popen('/bin/cp '..ipynb_name..' '..ipynb_sync_file))
	pair = assert(io.popen('/home/eetakala/miniconda3/bin/jupytext --to py:percent '..ipynb_sync_file))
	-- os.execute("/home/eetakala/miniconda3/bin/jupyter notebook")
	return ipynb_sync_file
end

local function set_up_jupyter_ascending_for_ipynb_file()
	ipynb_name = vim.fn.expand('%')
	ipynb_sync_file = create_jupytext_pair(ipynb_name)
	py_sync_file = filebase(ipynb_name)..".sync.py"
	start_jupyter_notebook(ipynb_sync_file)
	vim.cmd('sp '..py_sync_file)
end

return {
	start_jupyter_notebook = start_jupyter_notebook,
	read_jupyter_notebook = read_jupyter_notebook,
	stop_jupyter_notebook = stop_jupyter_notebook,
	create_jupytext_pair = create_jupytext_pair,
	set_test_mappings = set_test_mappings,
	fetch_notebook_servers = fetch_notebook_servers,
	set_up_jupyter_ascending_for_ipynb_file = set_up_jupyter_ascending_for_ipynb_file,
	set_test_mappings = set_test_mappings
}
