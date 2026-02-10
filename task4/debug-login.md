# Commands to Debug Login Service

Run these commands on your student-vm to diagnose the login issue:

```bash
# 1. Check if ingress is deployed
kubectl get ingress

# 2. Check login service logs for errors
kubectl logs -l app=spring-login --tail=100

# 3. Verify the login service is accessible internally
kubectl exec -it $(kubectl get pods -l app=spring-login -o jsonpath='{.items[0].metadata.name}') -- curl -I http://localhost:8080

# 4. Check if the ingress controller can reach the login service
INGRESS_IP=$(kubectl get ingress wecloud-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -I http://$INGRESS_IP/login

# 5. Test login with a test user (replace with actual credentials from LoginApplication.java)
curl -X POST http://$INGRESS_IP/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=testuser&password=testpass"
```
