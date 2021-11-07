# jupyter-nvim
A minimal jupyter plugin for managing jupyter notebook servers and for setting up jupyter_ascending (https://github.com/untitled-ai/jupyter_ascending) pairing.

# installation
Installation using vim-plug the usual way
```
Plug 'ER-solutions/jupyter-nvim', {'branch':'main'}
```

# Requirements
For making the pairing with .sync.ipynb and .sync.py

```pip install jupytext```

If you want to synchronize the .sync.ipynb file with your .sync.py file, you should install the jupyter_ascending: see installation at https://github.com/untitled-ai/jupyter_ascending

And the vim client https://github.com/untitled-ai/jupyter_ascending.vim

```Plug 'untitled-ai/jupyter_ascending.vim'```

# Use case
1. Open a .ipynb file with nvim (for example "test.ipynb", see under test folder) ```nvim test.ipynb``` - nvim opens a raw rendering of the .ipynb file.
2. Press <enter> - nvim-jupyter manages the pairing: test.sync.ipynb (a copy of test.ipynb) and test.ipynb.py (jupytext rendering of the test.sync.ipynb) - nvim-jupyter opens the test.sync.py file that the user can edit
3. Press <space><space><enter> - nvim-jupyter opens a floating window that allows to see all the notebook servers
4. Assuming there are no servers running press <enter> - a jupyter notebook server at the current filepath is started and the floating window contains now one line with the information of that server with the cursor pointing to its line
5. Press <enter> - nvim-jupyter starts a web browser and a client session at the server address
6. Open "test.sync.ipynb" on the client
7. Modify test.sync.py on nvim and save - jupyter_ascending updates the test.sync.ipynb accordingly
8. Save test.sync.ipynb file on the web client and press <space><spcase>w on the nvim - jupyter-nvim applies the changes made on test.sync.ipynb to test.ipynb (copies test.sync.ipynb to test.ipynb)


  



