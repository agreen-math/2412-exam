# Template CheckIt Bank

## Usage

- Click "Use this template" to create a new repository.
- On the new repository, click "Code" and select the "Codespaces" tab.
  Then click "Create codespace on main".
- After it finishes "Setting up remote connection",
  you should be good to go once the following message displays
  in a terminal:

```
devcontainer process exited with exit code 0
Finished configuring codespace.
```

- Open a new terminal and run `sage --python -m checkit --help` for options.

## Previewing bank

Quick instructions:

```
sage --python -m checkit generate  # add -ri to get images (slow)
sage --python -m checkit viewer
sage --python -m http.server 8000 -d docs --bind 0.0.0.0
```
This regenerates a particular outcome:

sage --python -m checkit generate -r -o name_of_outcome_folder

If you open forwarded port 8000 before starting the server, Codespaces will return HTTP 502.

## About CheckIt

Learn more at <https://github.com/StevenClontz/checkit>
and <https://github.com/StevenClontz/checkit/wiki>.
