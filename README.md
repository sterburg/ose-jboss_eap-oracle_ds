# ose-jboss_eap-oracle_ds

This uses jboss-eap-openshift docker image and adds support for the Oracle JDBC driver as a jboss module + modified sti/run script to "service discovery" openshift oracle services as jboss datasources.

# Details

- Modified standalone-openshift.xml to include the Oracle Driver
- Modified s2i/run script to include type "ORACLE" datasource type.


# Service Discovery

Datasources are automatically created based on the value of some environment variables.

The most important is the DB_SERVICE_PREFIX_MAPPING environment variable which defines JNDI mappings for data sources. It must be set to a comma-separated list of <name>_<database_type>=<PREFIX> triplets, where name is used as the pool-name in the data source, database_type determines what database driver to use, and PREFIX is the prefix used in the names of environment variables, which are used to configure the data source.

For each <name>-<database_type>=PREFIX triplet in the DB_SERVICE_PREFIX_MAPPING environment variable, a separate datasource will be created by the launch script, which is executed when running the image.
The <database_type> will determine the driver for the datasource. The jboss_eap only supports postgresql and mysql, i added oracle.

## External Services

See https://docs.openshift.com/enterprise/3.0/dev_guide/integrating_external_services.html

Create a <service> & <endpoints> object pointing to your Oracle RAC cluster (scanaddresses).
This service will be automatically added by Kubernetes as ENVironment variables to your running container: <NAME>_<DATABASE_TYPE>_SERVICE_HOST  && <NAME>_<DATABASE_TYPE>_SERVICE_PORT (aka "Service Discovery").

