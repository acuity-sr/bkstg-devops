# Azure Kubernetes DevOps

This module documents the various pieces needed to deploy a traditional web app using kubernetes on Azure.

Assumes the app is a traditional 3-tier app:

- front-end: a web client
- back-end: an API service (a nodejs app in this example)
- database: a SQL database server (we presume postgres and that we will use the Azure managed postgres service)

## 0.1 Pre-requisites

Before we can proceed, we will need to ensure the following programs are installed on your system/environment. These are hard to automate reliably
across the various OS', and require you to personally tend to them.

[List of pre-requisites installations](./docs/pre-reqs.md). It's a bit of busy work, but only in aide of making the rest of this exercise smoother. Best of all, we'll wait while you are at it.

![busy work](./docs/images/keyboard-clicking.gif)

Welcome back!

## 0.2 Create the backstage-app

This is likely only needed if restarting the project from scratch. In all likelihood, you are working with an already created app and a `git clone` of
the repo.

For the sake of completeness, if you need to start from scratch, run the following command to create a new backstage-app.

NOTE: If in doubt, select an SQLITE database. We will presume that you selected the postgres database for deployment purposes.

If you are unsure, it's ok to generate the application with a sqlite datastore. Presuming we called the app `bkstg`, this creates a mono-repo with two npm "packages"

```
bkstg
└── packages
    ├── app       # the front-end/web-ui
    └── backend   # the api server - this connects to a database.
```

`npx @backstage/create-app`

This step does a `yarn install` - which takes a bit to complete.

![time sink](./docs/images/time-passing.gif)

If you find yourself contemplating the end-of-time, instead consider jumping ahead to the next section.

## Some Background

This document is targeted at engineers who might be very competent and senior, but are new to the dev-ops landscape, Azure, and Kubernetes. It is not meant to be a comprehensive tutorial. However, if you only have the time to read this document, we provide curated links to external resources that you might find to be of good value (and to boost the "wholesome" claims of this document!)

### Cattle Not Pets

A requirement of modern reliable systems is quick recovery from any kind of failure. A recurring meme around this notion is to treat infrastructure and indeed any part of the application itself as ["cattle not pets"](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/)

> In the old way of doing things, we treat our servers like pets, for example Bob the mail server. If Bob goes down, it’s all hands on deck. The CEO can’t get his email and it’s the end of the world. In the new way, servers are numbered, like cattle in a herd. For example, www001 to www100. When one server goes down, it’s taken out back, shot, and replaced on the line.

### Azure Management Scope

When working with Azure, it's important understand how Azure organizes the infrastructure for management, billing and security purposes. While complex setups are probably an overkill here,
it is good to have a bare minimum of understanding, so we'll know where to go look when our needs grow.

[![Azure infra management structure](./docs/images/01_azure_scope_mgmt.png)](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/organize-resources?tabs=AzureManagementGroupsAndHierarchy)

This illustrates the basic structure of Azure's management hierarchy.

- _Management groups_: These groups are containers that help you manage access, policy, and compliance for multiple subscriptions. All subscriptions in a management group automatically inherit the conditions applied to the management group.
- _Subscriptions_: A subscription logically associates user accounts and the resources that were created by those user accounts. Each subscription has limits or quotas on the amount of resources you can create and use. Organizations can use subscriptions to manage costs and the resources that are created by users, teams, or projects.
- _Resource groups_: A resource group is a logical container into which Azure resources like web apps, databases, and storage accounts are deployed and managed.
- _Resources_: Resources are instances of services that you create, like virtual machines, storage, or SQL databases.

In the remainder of this exercise, we will assume that your "Azure login" is bound to a "subscription" with sufficient privileges, and will work creating `resource-groups` and `resources`.

> It's possible that our `yarn install` has completed by this point. Jump ahead to [#]().
> We'll refer you back to this section before it becomes necessary.

### Kubernetes

Azure provides a [quick introduction to Kubernetes](https://azure.microsoft.com/en-us/topic/what-is-kubernetes/). If you are just getting started with kubernetes, this is a great place to get started.

If you are a seasoned engineer but new to Kubernetes, [Kubernetes Best Practices](https://www.youtube.com/watch?v=wGz_cbtCiEA&list=PLIivdWyY5sqL3xfXz5xJvwzFW_tlQB_GB) the playlist of 7 videos by Sandeep Dinesh from [Google Cloud Tech](https://www.youtube.com/channel/UCJS9pqu9BzkAMNTmzNMNhvg), is excellent. They run a bit over 50 minutes in total, but have
a very high signal to noise ratio. A good investment.

### Infrastructure as code
[Infrastructure as Code (IaC)](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code) is the notion of defining infrastructure in a file - typically uderstood to be as a data specification with a bit of embedded logic. Depending on the framework/tooling used, the balance between pure-data and all-code varies. The important part in any case is that the infrastructure is contained in a file and committed to version control.

### Git-ops/Infrastructure Lifecycle
This section got too large and complex to fit inline and not be a distraction. Read all about it [here](./infra-lifecycle/infra-lifecycle.md).


## Infrastructure Design
We now have an application to deploy, and a basic requirement that we are going to deploy 
the application over a kubernetes cluster on the Azure cloud. We also have a basic understanding of a concepts and pieces involved.

So with that, let's get started. 

We will be adapting the [AKS workshop architecture](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/01-introduction) to fit our needs. Specifically, there are two changes we anticipate
1. replacing `mongo-db` within the kubernetes cluster with an _Azure Managed Postgres_ instance
2. [TBD] adding an _Azure Key Vault_ to manage secrets (db credentials mainly)

Instead of building things up one step at a time, we will assume that the architecture works
and build for the final goal. Meaning, our script will not piece-meal the building to aide understanding. Please read/implement the workshop tutorial to gain that understanding. 

![Reference architecture](./docs/images/02_aks_workshop.svg)

### Infrastructure/Configuration inventory

These are the pieces that we'll need to provision/configure as part of our script.
They are also split up by stage of creation, allowing us automate with clear separation
of responsibility.

| Layer        |    Azure               | Kubernetes                 |
|--------------|------------------------|----------------------------|
| bootstrap    | service-principal      |                            |
|              | resource-group         |                            |
| infra        | azure-networking       |                            |
|              | AKS-cluster            |                            |
|              | ACR                    |                            |
|              | bind AKS-ACR           |                            |
|              | Azure-postgres         |                            |
|              | log-analytics workspace|                            |
|              | AKS monitoring addon   |                            |
| config       |                        | namespace                  |
|              |                        | api-Deployment             |
|              |                        | api-Service                |
|              |                        | LoadBalancer               |
|              |                        | ui-Deployment              |
|              |                        | ui-Service                 |
|              |                        | ingress                    |
|              |                        | cert-manager               |
|              |                        | ClusterRole(monitoring)    |
|              |                        | api-HorizontalPodAutoscaler|


## Globals
As with any automation, the point is to have an ability to modify this with slight changes to fit other needs. This could be deploying the same application to different stages (dev/test/staging/production), to different regions or even deploying different applications using the same template.

> Further, we will use [`doable`](https://github.com/acuity-sr/doable) to extract these into self contained scripts, making this an executable document!

To aide understanding and maintainability, the global variables are also split up by the stage when they are first used.

##### windows
```bat scripts/globals
rem bootstrap
set APP_NAME=acuity-bkstg
set REGION_NAME=eastus
set RESOURCE_GROUP=%APP_NAME%

rem infra
set SUBNET_NAME=%APP_NAME%-aks-subnet
set VNET_NAME=%APP_NAME%-aks-vnet

rem config


rem app

```

##### *nix
```sh scripts/globals
# bootstrap
APP_NAME=acuity-bkstg
REGION_NAME=eastus
RESOURCE_GROUP=$APP_NAME

# infra
SUBNET_NAME=$APP_NAME-aks-subnet
VNET_NAME=$APP_NAME-aks-vnet

# config

# app
```

## Bootstrap

##### windows
```bat scripts/bootstrap
```

##### *nix
```sh scripts/bootstrap
```

## Infrastructure

##### windows
```bat scripts/infra
```

##### *nix
```sh scripts/infra
```

## config

### Api 
#### Deployment
```yaml scripts/api-deployment.yml
```
#### Service
```yaml scripts/api-service.yml
```

### UI
#### Deployment
```yaml scripts/ui-deployment.yml
```
#### Service
```yaml scripts/ui-service.yml
```


