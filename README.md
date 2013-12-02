Nagios probes for OpenNebula v3.4 - v4.4
========================================

[![Build Status](https://travis-ci.org/arax/opennebula-nagios-probes.png)](https://travis-ci.org/arax/opennebula-nagios-probes)

Nagios probes for OpenNebula-related services e.g. econe-server, occi-server
and oned RPC2.

These probes are written in Ruby, Gemfile for bundler is included.

## Requirements
1.9.1 =< Ruby version =< 2.0.0

## Usage

~~~
./check_opennebula.rb --username <USERNAME> --password <PASSWORD> --hostname <HOSTNAME> --port <PORT_NUMBER>  --service occi
./check_opennebula.rb --username <USERNAME> --password <PASSWORD> --hostname <HOSTNAME> --port <PORT_NUMBER> --path /RPC2  --service oned
./check_opennebula.rb --username <USERNAME> --password <PASSWORD> --hostname <HOSTNAME> --port <PORT_NUMBER>  --service econe
~~~

and with optional

* `--timeout` (this option is, for now, ignored by OCCI and ECONE probes)
* `--protocol [https | http]`
* `--debug`
* `--check-network <ID>,<ID>,<ID>,...` (this option is ignored by the ECONE probe)
* `--check-storage <ID>,<ID>,<ID>,...`
* `--check-compute <ID>,<ID>,<ID>,...`
