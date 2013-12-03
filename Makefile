
OPENERP_ADDONS=openerp-web/addons/,.
COVERAGE?=coverage
COVERAGE_REPORT=$(COVERAGE) report -m
COVERAGE_PARSE_RATE=$(COVERAGE_REPORT) | tail -n 1 | sed "s/ \+/ /g" | cut -d" " -f4
OE=whereis oe | cut -d" " -f2
DROP_DB=echo 'DROP DATABASE testdb;' | psql

test: openerp-web
	createdb testdb
	openerp-server --addons=$(OPENERP_ADDONS) --stop-after-init -d testdb
	openerp-server --addons=$(OPENERP_ADDONS) -i superhalles --test-enable --log-level=test --stop-after-init -d testdb
	$(DROP_DB)

test-oe:
	createdb testdb
	openerp-server --addons=$(OPENERP_ADDONS) -i superhalles --stop-after-init -d testdb
	$(COVERAGE) run -p --omit=superhalles/__openerp__.py --source=superhalles `$(OE)` run-tests -d testdb --addons $(OPENERP_ADDONS) -m superhalles || $(DROP_DB) && exit 1
	$(DROP_DB)
	$(COVERAGE) combine
	$(COVERAGE_REPORT)
	if [ "100%" != "`$(COVERAGE_PARSE_RATE)`" ] ; then exit 1 ; fi

clean:
	rm -rf openerp-web

openerp-web:
	git clone https://github.com/akretion/openerp-web.git

server:
	openerp-server --addons=$(OPENERP_ADDONS) -d testdb
