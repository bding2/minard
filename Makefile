default: build

INSTALL=install

.DEFAULT:
	./setup.py $@

build:
	./setup.py build

docs:
	$(MAKE) -C docs html
	@mkdir -p minard/static/docs
	cp -r docs/_build/html/* minard/static/docs

/opt/minard/bin/activate:
	sudo rm -rf /opt/minard
	sudo virtualenv -p python3 --system-site-packages /opt/minard

install: /opt/minard/bin/activate
# 	# clean the build/ directory since it contains scripts with the shebang pointing to /usr/bin/python after running make build
	sudo python3 setup.py clean --all

#   # install dependencies
	sudo /opt/minard/bin/pip install --upgrade pip
	sudo /opt/minard/bin/pip install .

# 	# copy static files to /var/www/minard so that nginx can serve them instead of flask
	mkdir -p /var/www/minard
	sudo cp -r minard/static /var/www/minard

# 	# install to initialization directories and start services
	sudo $(INSTALL) init/gunicorn.service /etc/systemd/system
	sudo $(INSTALL) init/gunicorn_snoplus_log.service /etc/systemd/system
	sudo $(INSTALL) init/minard-dispatch.service /etc/systemd/system
	sudo $(INSTALL) init/minard-cmos.service /etc/systemd/system
	sudo $(INSTALL) init/minard-base.service /etc/systemd/system
	sudo $(INSTALL) init/baseline_monitor.service /etc/systemd/system
	sudo $(INSTALL) init/dispatch.service /etc/systemd/system
	sudo $(INSTALL) init/xsnoed.service /etc/systemd/system

	sudo systemctl enable gunicorn
	sudo systemctl enable gunicorn_snoplus_log
	sudo systemctl enable minard-dispatch
	sudo systemctl enable minard-cmos
	sudo systemctl enable minard-base
	sudo systemctl enable baseline_monitor
	sudo systemctl enable dispatch
	sudo systemctl enable xsnoed

	sudo systemctl start gunicorn
	sudo systemctl start gunicorn_snoplus_log
	sudo systemctl start minard-dispatch
	sudo systemctl start minard-cmos
	sudo systemctl start minard-base
	sudo systemctl start baseline_monitor
	sudo systemctl start dispatch
	sudo systemctl start xsnoed


.PHONY: install build docs
