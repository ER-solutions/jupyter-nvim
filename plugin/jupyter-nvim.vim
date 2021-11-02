" fun! TestPlugin()
" 	lua for k in pairs(package.loaded) do if k:match("^jupyter%-nvim") then package.loaded[k] = nil end end
" 	lua require("jupyter%-nvim").test()
" endfun

" let g:global_test_var = "test"

augroup filetype_jupyternb
 	au!
 	" au FileType jupyter-notebook lua require("jupyter-nvim").set_up_jupyter_ascending_for_ipynb_file()
	" au BufUnload *.ipynb :lua require("jupyter-nvim").stop_jupyter_notebook()
 	au FileType jupyter-notebook nnoremap <buffer> <enter> :lua require("jupyter-nvim").fetch_notebook_servers()<CR>
augroup end
 
