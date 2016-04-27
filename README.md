# ose-jboss_eap-oracle_ds

This uses jboss-eap-openshift docker image and adds support for the Oracle JDBC driver as a jboss module + modified sti/run script to "service discovery" openshift oracle services as jboss datasources + adds Flyway as a pre-deployment hook to execute database-versioning sql-scripts.

# Details

- Modified standalone-openshift.xml to include the Oracle Driver
- Modified s2i/run script to include type "ORACLE" datasource type.
- Added flyway as a pre-hook to the RollingUpdate deployment-strategy in the examples/sample-app-dc-flyway.yml deploymentconfig object.


# Service Discovery

Datasources are automatically created based on the value of some environment variables.

The most important is the DB_SERVICE_PREFIX_MAPPING environment variable which defines JNDI mappings for data sources. It must be set to a comma-separated list of <name>_<database_type>=<PREFIX> triplets, where name is used as the pool-name in the data source, database_type determines what database driver to use, and PREFIX is the prefix used in the names of environment variables, which are used to configure the data source.

For each <name>-<database_type>=PREFIX triplet in the DB_SERVICE_PREFIX_MAPPING environment variable, a separate datasource will be created by the launch script, which is executed when running the image.  
The <database_type> will determine the driver for the datasource. The jboss_eap only supports postgresql and mysql, i added oracle.


## External Services

See https://docs.openshift.com/enterprise/3.0/dev_guide/integrating_external_services.html.  
See examples/oracle-svc.yml.

Create a <service> & <endpoints> object pointing to your Oracle RAC cluster (scanaddresses).  
This service will be automatically added by Kubernetes as ENVironment variables to your running container: `<NAME>_<DATABASE_TYPE>_SERVICE_HOST`  && `<NAME>_<DATABASE_TYPE>_SERVICE_PORT` (aka "Service Discovery").  
This service will also be automatically added by Kubernetes as a DNS entry: `<NAME>.<PROJECT>.svc.cluster.local` where `<PROJECT>.svc.cluster.local` is the default DNS suffix / search domain inside your other Docker containers running in the same project namespace, so you could use just `<NAME>` as the DNS request.


## Database Versioning

Use Flyway as your database versioning.  
Put your sql-scripts in /src/resources/sql as that will be compiled into your WAR-file and will be copied onto /home/jboss/source inside the target Docker image.  
By default flyway.sh will look in /home/jboss/source/src/resources/sql for any sql-scripts to execute.  
flyway.sh will use the env var OPENSHIFT_BUILD_REFERENCE as the target database_schema version.  
This env var OPENSHIFT_BUILD_REFERENCE is baked into the Docker image and takes its value from `{ spec: { source: { git: { ref }}}}` from the buildconfig. Usually this is a git tag (e.g. "v1").  
By using the git ref as the database schema version you keep your versioning the same throughout the whole pipeline.  
A roll-forward: `oc patch bc sample-app -p '{"spec": {"source": {"git": {"ref": "v2" } } } }'`  
A roll-back   : `oc patch bc sample-app -p '{"spec": {"source": {"git": {"ref": "v1" } } } }'`  
`oc start-build sample-app`  
You should ofcourse have rollback scripts in place to roll-back.


## Remarks 
This example is based on jboss-eap64-openshift:1.1-6. By now Red Hat has created newer versions of this base image which is incompatible with this example.  
The incompatibility is in the s2i/run script, which was refactored by Red Hat.

