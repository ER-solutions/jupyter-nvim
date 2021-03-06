# jupyter-nvim
A minimal jupyter plugin for managing jupyter notebook servers and for setting up jupyter_ascending (https://github.com/untitled-ai/jupyter_ascending) pairing.

# installation
Installation using vim-plug the usual way
```
Plug 'ER-solutions/jupyter-nvim', {'branch':'main'}
```

# Requirements
For making the pairing between .sync.ipynb and .sync.py

```pip install jupytext```

If you want to synchronize the .sync.ipynb file with your .sync.py (when you write the .sync.py file, .sync.ipynb file is updated accordingly in the jupyter web client that renders the .sync.ipynb file), you should install the jupyter_ascending: see installation at https://github.com/untitled-ai/jupyter_ascending

And the vim client https://github.com/untitled-ai/jupyter_ascending.vim

```Plug 'untitled-ai/jupyter_ascending.vim'```

# Use case
1. Open a .ipynb file with nvim (for example "test.ipynb", see under test folder) ```nvim test.ipynb``` - nvim opens a raw rendering of the .ipynb file.
2. Press ```<enter>``` - nvim-jupyter manages the pairing: creates test.sync.ipynb (a copy of test.ipynb) and test.ipynb.py (jupytext rendering of the test.sync.ipynb) - nvim-jupyter opens the test.sync.py file that the user can edit
3. Press ```<enter>``` to close the pairing dialog
4. Press ```<space><space><enter>``` - nvim-jupyter opens a floating window that allows to see all the notebook servers
5. Assuming there are no servers running press ```<enter>``` - a jupyter notebook server at the current filepath is started
6. Press ```<space><space><enter>``` - floating window contains now one line with the information of that server with the cursor pointing to it
7. Press ```<enter>``` - nvim-jupyter starts a web browser and a client session at the server address
8. Open "test.sync.ipynb" on the client
9. Modify test.sync.py on nvim and save - jupyter_ascending updates the test.sync.ipynb accordingly (NOTE that the jupyter_ascending vim plugin can control the notebook and for example normally pressing ```<space><space>X``` one can run the whole notebook from the start until end from nvim (see https://github.com/untitled-ai/jupyter_ascending.vim)
10. Save test.sync.ipynb file on the web client and press ```<space><space>w``` on the nvim - jupyter-nvim applies the changes made on test.sync.ipynb to test.ipynb (copies test.sync.ipynb to test.ipynb)
11. Press  ```<space><space><enter>``` - server list opens and cursor points to the running server
12. Press ```<backspace>``` - jupyter-nvim stops the jupyter notebook server that the cursor is pointing to



