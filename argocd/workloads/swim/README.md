# AFC dmbyteobjtransferapp

[Confluence Architecture Write-up](https://americanfinancing.atlassian.net/wiki/spaces/SE/pages/733315115/How+to+Deploy+GKE+Workloads+-+Sales+on+Rails)

## ToDo

- Staging and Production rollout.  Everything else is done.

## Links

- [Source Repo](https://bitbucket.org/americanfinancing/afc.pub.sub.dmrcvdapp/src/master/)

- [Jenkins Job](https://jenkins.afc-services.net/blue/organizations/jenkins/ai%2Fdmrcvdapp/activity)

- [Jenkins Pipeline](https://bitbucket.org/americanfinancing/afc-jenkins-devops/src/main/ai/pubsub-dmrcvdapp.Jenkinsfile)

- [Gitops Repo](https://bitbucket.org/americanfinancing/ai-gitops/src/main/workloads/dmrcvdapp/)

## Setup

These are the commands we ran to setup the service accounts, permission to PubSub/Firestore, and Workload Identity.


```bash
## Note: we removed firebase.admin and pubsub.publisher in QA on 9/20/2021 per architect feedback on permissions
# define service accounts (only QA is setup right now)
sa_name="svc-dmrcvd"
sa_qa="$sa_name@afc-qa01.iam.gserviceaccount.com"
sa_staging="$sa_name@afc-staging01.iam.gserviceaccount.com"
sa_prod="$sa_name@afc-prod01.iam.gserviceaccount.com"

gcloud iam service-accounts create $sa_name --project afc-qa01

# add roles for registry and storage
firebase_role='roles/firebase.admin'
pubsub_role_1='roles/pubsub.publisher'
pubsub_role_2='roles/pubsub.subscriber'

# this is the actual QA project hosting pubsub & firestore
gcloud projects add-iam-policy-binding --role="$firebase_role" ai-esb-qa --member "serviceAccount:$sa_qa"
gcloud projects add-iam-policy-binding --role="$pubsub_role_1" ai-esb-qa --member "serviceAccount:$sa_qa"
gcloud projects add-iam-policy-binding --role="$pubsub_role_2" ai-esb-qa --member "serviceAccount:$sa_qa"

# allow k8s service account to impersonate gcloud sa (iam policy binding)
gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:afc-qa01.svc.id.goog[dmrcvd/svc-dmrcvd]" $sa_qa --project afc-qa01

### Workload Identity - this is codified in ArgoCD manifests
#kubectl create serviceaccount -n dmrcvd svc-dmrcvdapp
#kubectl annotate serviceaccount -n dmrcvd svc-dmrcvdapp iam.gke.io/gcp-service-account=svc-dmrcvdapp@afc-qa01.iam.gserviceaccount.com

## Test to see if cluster has workload identity enabled
gcloud container clusters describe gcpqa01 --format="value(workloadIdentityConfig.workloadPool)" --project=afc-qa01

## Test k8s sa to GCP sa binding
gcloud iam service-accounts get-iam-policy svc-dmrcvd@afc-qa01.iam.gserviceaccount.com

```

