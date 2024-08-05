### bastionHost
#### Access info
- Address 
  - ${remote_addr}
- pem Keyname 
  - ${pem_keyname}.pem


#### EC2 join 
- `ssh -i pem_key ubuntu@${nexus_host}`
- `ssh -i pem_key ubuntu@${gitlab_host}`
