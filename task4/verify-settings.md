# Verification Commands

Please run these on your student-vm and paste the output:

```bash
# 1. Check if the NGINX IP has changed
kubectl get svc -n default | grep nginx

# 2. Check the Chat Service Database name
# Retrieve the MySQL root password
MYSQL_ROOT_PASS=$(kubectl get secret mysql-chat -o jsonpath='{.data.mysql-root-password}' | base64 -d)

# Connect to MySQL and list databases
kubectl exec -it mysql-chat-0 -- mysql -u root -p$MYSQL_ROOT_PASS -e "SHOW DATABASES;"
```
