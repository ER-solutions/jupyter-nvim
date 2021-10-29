fun! TestPlugin()
	lua for k in pairs(package.loaded) do if k:match("^jupyter%-nvim") then package.loaded[k] = nil end end
	lua require("jupyter%-nvim").test()
endfun

let g:global_test_var = "test"
