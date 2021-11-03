local function touch_file(filepath)
	file = io.open(filepath, "w")
	-- file:write("Hello World")
	file:close()
end

local function my_proc(name, cmd)
	path = vim.fn.expand('%:p:h')
	local proc = {}
	logfile = name..".log"
	touch_file(logfile)
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


return {
	my_proc = my_proc,
	read_proc = read_proc,
	close_proc = close_proc
}

