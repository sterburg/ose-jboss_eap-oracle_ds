docker run -d --name=oracle -p 49160:22 -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true wnameless/oracle-xe-11g
# oc adm policy add-scc-to-user anyuid system:serviceaccount:myproject:default
# oc new-app --docker-image=sterburg/oracle-xe-11g --name=oracle
# oc patch privileged:true + runAsUser:0
# oc create -f examples/oracle-dc.yml
