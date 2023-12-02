# Services

preparat
  - create a deployment with two pods
  - create a default NodePort service link to two pods
  - create a namespace with deployment and pod for question 8


1. list all the services existing on a given namespace
   
   kubectl get service

2. the type of services
   
    kubectl get service

3. get the tartget port of 
   
   kubectl describe svc <service_name>

4. how many endpoint are attached to the service
   
   kubectk describe svc <service_name>

5. how many deployment exist on the system
   
   kubectl get deploy

6. what is the image 

   kubectl describe deploy <deplyment_name>

7. create service to access a web application 


8. 