local function touch_file(filepath)
	local file = io.open(filepath, "w")
	-- file:write("Hello World")
	file:close()
end

local function my_proc(name, cmd)
	path = vim.fn.expand('%:p:h')
	local proc = {}
	local logfile = name..".log"
	local logpath_no_escape = path..'/'..logfile
	local logpath = vim.fn.fnameescape(path..'/'..logfile)
	local cmdpopen = cmd..' 2> '..logpath
	touch_file(logfile)
	proc.__handle = assert(io.popen(cmdpopen))
	proc.__file = assert(io.open(logpath_no_escape, 'r'))

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
	if (proc) then
		for line in proc:lines() do
			print(line)
		end
	end
end

local function close_proc(proc)
	if (proc) then 
		proc:close()
	end
end

local function my_execute(cmd)
	print(cmd)
	os.execute(cmd)
end

return {
	my_proc = my_proc,
	read_proc = read_proc,
	close_proc = close_proc,
	my_execute = my_execute
}

