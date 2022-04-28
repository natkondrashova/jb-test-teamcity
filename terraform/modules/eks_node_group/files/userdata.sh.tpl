#!/bin/bash -xe

${pre_userdata}

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh '${cluster_name}' --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}'

${post_userdata}