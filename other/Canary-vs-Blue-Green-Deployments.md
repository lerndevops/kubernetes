# Canary vs Blue-Green Deployments

### Both blue-green and canary releases solve the same purpose

### Although both of these terms look quite close to each other, they have subtle differences. One put confidence in your functionality release and the other put confidence the way you release.


## Blue-Green Deployment 
> When deploying a new version of an application, a second environment is created. Once the new environment is tested, it takes over from the old version. The old environment can then be turned off.

`1. It is more about the predictable release with zero downtime deployment.`

`2. Easy rollbacks in case of failure.`

`3. Completely automated deployment process`

`4. In cloud environment where it is easier to script & recreate infrastructure, blue/green deployment is preferred as it allows the infrastructure to be in sync with the automation`

## Canary Release 
> A new version of a microservice is started along with the old versions. That new version can then take a portion of the requests and the team can test how this new version interacts with the overall system.

`1. The canary release is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure.`

`2. It is about to get an idea of how new version will perform (integrate with other apps, CPU, memory, disk usage, etc).`



