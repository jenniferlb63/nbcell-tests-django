run:
	python3 -m jupyterlab_celltests.tests Untitled.ipynb

testjs: ## Clean and Make js tests
	npm run test

testpy: ## Clean and Make unit tests
	python3 -m nose -v tests --with-coverage --cover-erase --cover-package=`find jupyterlab_celltests -name "*.py" | sed "s=\./==g" | sed "s=/=.=g" | sed "s/\.py//g" | tr '\n' ',' | rev | cut -c2- | rev`
	
test: lint ## run the tests for travis CI
	@ python3 -m nose -v tests --with-coverage --cover-erase --cover-package=`find jupyterlab_celltests -name "*.py" | sed "s=\./==g" | sed "s=/=.=g" | sed "s/\.py//g" | tr '\n' ',' | rev | cut -c2- | rev`
	npm install && npm run test

lint: ## run linter
	pylint jupyterlab_celltests || echo
	flake8 jupyterlab_celltests 

annotate: ## MyPy type annotation check
	mypy -s jupyterlab_celltests

annotate_l: ## MyPy type annotation check - count only
	mypy -s jupyterlab_celltests | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	find . -name ".ipynb_checkpoints" | xargs  rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info lib node_modules
	# make -C ./docs clean

install:  ## install to site-packages
	python3 setup.py install

serverextension: install ## enable serverextension
	jupyter serverextension enable --py jupyterlab_celltests

labextension: install ## enable labextension
	jupyter labextension install .

dist:  ## dist to pypi
	python3 setup.py sdist upload -r pypi

# docs:  ## make documentation
# 	make -C ./docs html

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean install serverextension labextension test tests help docs dist
