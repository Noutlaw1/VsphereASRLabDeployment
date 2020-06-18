# VsphereASRLabDeployment
Terraform/Ansible to deploy an Azure Site Recovery lab to an on-prem VSphere environment.

This project is very similar to my other repository here: https://github.com/Noutlaw1/VMwareASRConfigServerInstallScript

The main idea is to do the same thing except with a vSphere environment as the target.

General flow i am going for is this:

1. Terraform kicks off the Vsphere provisioning jobs based on a trigger (Maybe a CI/CD pipeline?). We can use a vSphere template which does pre-configuration steps on provisioning to set up for Ansible access.
3. Ansible pushes out the configuration/process server software to the configuration server (CXPS-) via Powershell script as well as a certificate to authenticate with service principal.
4. Once the CS/PS is installed, the install script registers the CS to a pre-defined Recovery Vault, creates replication policies, etc.
5. Once that is done, Ansible connects to the replicated machine, pushes the mobility agent, installs and registers it to configuration server.
6. Lastly, replication needs to be enabled. I am not yet sure how I am going to do that but likely I will have Ansible do it.
