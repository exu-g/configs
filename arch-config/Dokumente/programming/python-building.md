# python building for pypi

Create a setup.py file.  

Execute in main program directory.  
```bash
python setup.py bdist_wheel sdist
```

Upload to pypi  
```bash
twine upload --skip-existing dist/*
```
