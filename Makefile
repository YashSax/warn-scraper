#
# Colors
# 

# Define ANSI color codes
RESET_COLOR   = \033[m

BLUE       = \033[1;34m
YELLOW     = \033[1;33m
GREEN      = \033[1;32m
RED        = \033[1;31m
BLACK      = \033[1;30m
MAGENTA    = \033[1;35m
CYAN       = \033[1;36m
WHITE      = \033[1;37m

DBLUE      = \033[0;34m
DYELLOW    = \033[0;33m
DGREEN     = \033[0;32m
DRED       = \033[0;31m
DBLACK     = \033[0;30m
DMAGENTA   = \033[0;35m
DCYAN      = \033[0;36m
DWHITE     = \033[0;37m

BG_WHITE   = \033[47m
BG_RED     = \033[41m
BG_GREEN   = \033[42m
BG_YELLOW  = \033[43m
BG_BLUE    = \033[44m
BG_MAGENTA = \033[45m
BG_CYAN    = \033[46m

# Name some of the colors
COM_COLOR   = $(DBLUE)
OBJ_COLOR   = $(DCYAN)
OK_COLOR    = $(DGREEN)
ERROR_COLOR = $(DRED)
WARN_COLOR  = $(DYELLOW)
NO_COLOR    = $(RESET_COLOR)

OK_STRING    = "[OK]"
ERROR_STRING = "[ERROR]"
WARN_STRING  = "[WARNING]"

define banner
    @echo "  $(BLUE)__________$(RESET_COLOR)"
    @echo "$(BLUE) |$(RED)BIG  LOCAL$(RESET_COLOR)$(BLUE)|$(RESET_COLOR)"
    @echo "$(BLUE) |&&& ======|$(RESET_COLOR)"
    @echo "$(BLUE) |=== ======|$(RESET_COLOR)"
    @echo "$(BLUE) |=== == %%%|$(RESET_COLOR)"
    @echo "$(BLUE) |[_] ======|$(RESET_COLOR)"
    @echo "$(BLUE) |=== ===!##|$(RESET_COLOR)"
    @echo "$(BLUE) |__________|$(RESET_COLOR)"
    @echo ""
    @echo " $(RED)$(1)$(RESET_COLOR)"
    @echo ""
    @echo ""
endef

#
# Python helpers
#

PIPENV := pipenv run
PYTHON := $(PIPENV) python -W ignore

define python
    @echo "🐍🤖 $(OBJ_COLOR)Executing Python script $(1)$(NO_COLOR)\r";
    @$(PYTHON) $(1)
endef

#
# Cleaning
#

## remove all build, test, coverage and Python artifacts
clean: clean-build \
       clean-pyc

clean-build: ## remove build artifacts
	@rm -fr build/
	@rm -fr dist/
	@rm -fr .eggs/
	@find . -name '*.egg-info' -exec rm -fr {} +
	@find . -name '*.egg' -exec rm -f {} +


clean-pyc: ## remove Python file artifacts
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +

#
# Tests
#

lint: ## run the linter
	@$(PIPENV) flake8 ./


test: ## run all tests
	$(call banner,Running tests)
	@$(PYTHON) setup.py test


coverage: ## check code coverage quickly with the default Python
	@$(PIPENV) coverage run --source warn -m pytest
	@$(PIPENV) coverage report -m

#
# Releases
#

check-release: ## check release for potential errors
	@$(PIPENV) twine check dist/*


test-release: clean dist ## release distros to test.pypi.org
	@$(PIPENV) twine upload -r testpypi dist/*


release: clean dist ## package and upload a release
	@$(PIPENV) twine upload -r pypi dist/*


dist: clean ## builds source and wheel package
	@$(PYTHON) setup.py sdist
	@$(PYTHON) setup.py bdist_wheel
	@ls -l dist

#
# Extras
#

docs: ## start the documentation test server
	cd docs && $(PIPENV) make livehtml;


format: ## automatically format Python code with black
	@$(PIPENV) black .


help: ## Show this help. Example: make help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


# Mark all the commands that don't have a target
.PHONY: help \
        check-release \
        clean \
        clean-test \
        clean-pyc \
        docs \
        dist \
        format \
        release \
        test \
        test-release
