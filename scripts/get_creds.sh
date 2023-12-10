#! /bin/bash
namespace=argocd; 
secret=argocd-initial-admin-secret;
secret=$(kubectl get secret -n $namespace $secret -o json)
password_key=password;
password=$(echo $(echo $secret | jq --raw-output ".data.\"$password_key\"") | base64 -d)
if [ ! -z "$user_key" ];
then
    user=$(echo $(echo $secret |  jq --raw-output ".data.\"$user_key\"") | base64 -d)
else
    user=admin
fi

echo "Username: $user"
echo "Password: $password"
