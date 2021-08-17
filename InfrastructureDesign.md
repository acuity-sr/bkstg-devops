## Infrastructure Design

We will be adapting the [AKS workshop architecture](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/01-introduction) to fit our needs. Specifically, there are two changes we anticipate

1. replacing `mongo-db` within the kubernetes cluster with an _Azure Managed Postgres_ instance
2. [TBD] adding an _Azure Key Vault_ to manage secrets (db credentials mainly)

Instead of building things up one step at a time, we will assume that the architecture works and build for the final goal.

Meaning, our script will not take a piece-meal approach to build+test, but present the pieces of the full script with annotations as necessary and run the full script at the end.

![Reference architecture](./docs/images/02_aks_workshop.svg)

At some point in the future, we hope to incorporate as much of the security and governance capabilities as appropriate. The [Security and Governance workshop](https://github.com/Azure/sg-aks-workshop) will serve as a starting point for that exercise. The link is only provided here for (future) reference.

### Infrastructure/Configuration inventory

These are the pieces that we'll need to provision/configure as part of our script.
They are also split up by stage of creation, allowing us automate with clear separation
of responsibility.

| Layer     | Azure                   | Kubernetes                  |
| --------- | ----------------------- | --------------------------- |
| bootstrap | resource-group          |                             |
|           | service-principal       |                             |
|           | Azure AD application    |                             |
| infra     | azure-networking        |                             |
|           | AKS-cluster             |                             |
|           | ACR                     |                             |
|           | bind AKS-ACR            |                             |
|           | Azure-postgres          |                             |
|           | log-analytics workspace |                             |
|           | AKS monitoring addon    |                             |
| config    |                         | namespace                   |
|           |                         | api-Deployment              |
|           |                         | api-Service                 |
|           |                         | LoadBalancer                |
|           |                         | ui-Deployment               |
|           |                         | ui-Service                  |
|           |                         | ingress                     |
|           |                         | cert-manager                |
|           |                         | ClusterRole(monitoring)     |
|           |                         | api-HorizontalPodAutoscaler |

### Automation

As with any automation, the point here is to have an ability to apply the general template being developed here to fit other needs.

Other needs could include deploying

- the same application to different environments (dev/test/staging/production etc)
- the same application to different regions
- different applications using the same template

> Further, we will use [`doable`](https://github.com/acuity-sr/doable) to extract these into self contained scripts, making this an executable document!

The [infrastructure lifecyle](#infrastructure-lifecycle) sequence diagram lists the various operations we anticipate needing as part of any reasonable service in the cloud.

To wit, these are the use-cases that are planned on being supported (eventually):

1. **Creation**, developer initiated, provision some/all of the infra, kubernetes and app
2. **Update (application)**, developer initiated, typically the raison d'etre for this tooling
3. **Update (kubernetes)**, developer or ops driven action to better manage load or changing requirements
4. **Update (infrastructure)**, ops driven to manage load, developer driven to adapt architecture
5. **Delete (app)**, end-of-life or migration driven
6. **Delete (kubernetes)**, typically triggered by migration/deletion of underling infrastructure
7. **Delete (infrastructure)**, scaling or migration driven
8. **Destroy**, panic mode teardown of everything - in production should only by triggered under attack - for security or cost reasons. When "stopping-the-pain-right-now" is more important than we need a guarantee that we and isolate the fault. Interestingly, this can also be used in dev (non-production), to tear down infrastructure to minimize idle-time-billing.

> Caution: all delete/destroy operations in production (or with "real customers") will need to be protected from accidental execution. This is currently not addressed as part of this document or implementation. TBD

For a phase 1 implementation, we will

- not provide any protections/safeguards against foot-guns for #3,4,8. Operation caution advised to prevent catastrophic errors
- skip items #4-7
