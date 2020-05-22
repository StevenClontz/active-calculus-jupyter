# active-calculus-jupyter

You'll need a copy of Active Prelude to Calculus in the folder `apc`:

```
git clone https://github.com/active-calculus/prep.git apc
```

To provision python libraries: *(replace `python` with `python3` if necessary)*

```
python3 -m pip install pipenv
python -m pipenv install
```

To build the notebooks:

```
python -m pipenv run python build.py
```
