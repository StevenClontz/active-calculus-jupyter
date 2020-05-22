# active-calculus-jupyter

Jupyter notebooks for [ActiveCalculus.org](https://activecalculus.org) activities.
Preview at [CoCalc.com](https://share.cocalc.com/share/d175250ef74d96b440e7753e3235543865700ab6/active-calculus-jupyter/).

[![screenshot.png](screenshot.png)](https://share.cocalc.com/share/d175250ef74d96b440e7753e3235543865700ab6/active-calculus-jupyter/)

## Installation

You'll need a copy of Active Prelude to Calculus in the folder `apc`:

```
git clone https://github.com/active-calculus/prep.git apc
```

To provision python libraries: *(replace `python` with `python3` if necessary)*

```
python -m pipenv install
```

To build the notebooks:

```
python -m pipenv run python build.py
```