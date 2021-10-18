# Ansible Task

There is a bonus point outlined as:

- Using Ansible to ensure NTP is installed and running on the worker nodes

## Alternate Solution

I would recommend a different approach rather than applying the ansible playbook with Packer. 

- Setup Dynamic inventory so our EKS nodes automatically get added to AWX inventory.

- Have a role and playbook already plugged into the group that the EKS nodes would get added to.

- Have a scheduled job (I name mine "Drift Control") to make sure NTP config is consistent across the platform.

Since remediation of drift is already in place, I'd argue that the Packer pattern might be able to be deprecated.

I suspect I'm also rusty with Packer.  It's been a bit of time since I did it, so in the interest of time and focus on other areas, I skipped this step.
