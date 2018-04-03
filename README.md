## SLURM Cluster Via Docker

This is a minimal and bad, but **Working!** example of a Slurm (aka slurm-wlm, aka slurm llnl) compute cluster. This should work on bare metal ubuntu 18.04 machines, or in docker.

This isn't anywhere near production ready, treat it as useful infomration on your own slurm sysadmin quest.

I couldn't get slurm to compile reliantly, so I'm using the verison from Ubuntu's Repos. Ubuntu 18.04 has a resonably new version.

#### Slurm images ####

There are three images
- slurm_ctld - Slurm controller
- slurm_node - lurm compute node
- hpc_frontend - has slurm commandline tools, a simulation to how you may setup your own cluster 

#### LDAP ####

An annoying trait of slurm is that if user Bob runs a job, Bob must have an account on every node that the job runs on.

I've taken the LDAP route to sync users accross the cluster.
Docker image l**dap_host** hosts an ldap server, with a php web interface ( "lam" dap-account-manager. Beacuse phpldapadmin is old and busted).

Each of the other docker images are configured as LDAP clients. If you are using this for your own infrastructure it shouldn't be too hard to drop my ldap host image and use your own ldap server.


## No Warranty
I've wasted far too many weekends getting slurm to work.

I hope you fid this usefull

Don't expect this to work forever.